defmodule Uploadex.Files do
  @moduledoc """
  Functions to store and delete files.
  This is an abstraction on top of the [Arc.Actions.Store](https://github.com/stavro/arc/blob/master/lib/arc/actions/store.ex) and [Arc.Actions.Delete](https://github.com/stavro/arc/blob/master/lib/arc/actions/delete.ex), dealing with all files of a given record.
  """

  @doc """
  Stores all files of a record, as defined by the uploader.
  Used in insert functions.

  Since uploader.store only accepts maps, files that are not in that format are ignored.
  This allows for assigning an existing file to a record without recreating it, by simply passing it's filename.
  """
  def store_files(record) do
    uploader = Uploadex.uploader()

    record
    |> uploader.do_get_files()
    |> Enum.filter(&is_map/1)
    |> do_store_files(record)
  end

  # Recursively stores all files, stopping if one operation fails.
  defp do_store_files([file | remaining_files], record) do
    case Uploadex.uploader().store({file, record}) do
      {:ok, _file} -> do_store_files(remaining_files, record)
      {:error, error} -> {:error, error}
    end
  end

  defp do_store_files([], record) do
    {:ok, record}
  end

  @doc """
  Deletes all files that changed.
  Used in update functions.
  """
  def delete_previous_files(new_record, previous_record) do
    new_files = Uploadex.uploader().do_get_files(new_record)
    old_files = Uploadex.uploader().do_get_files(previous_record)

    new_files
    |> get_changed_files(old_files)
    |> do_delete_files(new_record)

    {:ok, new_record}
  end

  @doc """
  Deletes all files for a record.
  Used in delete functions.
  """
  def delete_files(record) do
    uploader = Uploadex.uploader()
    record
    |> uploader.do_get_files()
    |> do_delete_files(record)

    {:ok, record}
  end

  # Deletes all files, since uploader.delete always returns :ok, there is no extra logic for stopping when one operation fails.
  defp do_delete_files(files, record) when is_list(files) do
    Enum.each(files, fn file ->
      :ok = Uploadex.uploader().delete({file, record})
    end)
  end

  # Returns all old files that are not in new files.
  defp get_changed_files(new_files, old_files) do
    old_files -- new_files
  end
end
