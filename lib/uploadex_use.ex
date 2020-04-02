defmodule Uploadex.UploadexUse do
  @moduledoc """
  Concept module that would centralize all Uploadex function calls to avoid global configuratiob
  """

  defmacro __using__(opts \\ []) do
    repo = Keyword.get(opts, :repo)

    quote do
      @behaviour Uploadex.Uploader

      alias Uploadex.Files

      ## Files
      def store_files(record), do: Files.store_files(record, __MODULE__)
      def delete_previous_files(new_record, previous_record), do: Files.delete_previous_files(new_record, previous_record, __MODULE__)
      def delete_files(record), do: Files.delete_files(record, __MODULE__)

      def get_file_url(record, file, field), do: Files.get_file_url(record, file, field, __MODULE__)
      def get_files_url(record, field), do: Files.get_files_url(record, field, __MODULE__)
      def get_files_url(record, files, field), do: Files.get_files_url(record, files, field, __MODULE__)

      def get_temporary_file(record, file, path, field), do: Files.get_temporary_file(record, file, field, path, __MODULE__)
      def get_temporary_files(record, path, field), do: Files.get_temporary_files(record, path, field, __MODULE__)
      def get_temporary_files(record, files, path, field), do: Files.get_temporary_files(record, files, path, field, __MODULE__)

      ## Uploadex
      def create_with_file(changeset, opts \\ []), do: Uploadex.create_with_file(changeset, unquote(repo), opts)
      def update_with_file(changeset, previous_record, opts \\ []), do: Uploadex.update_with_file(changeset, previous_record, unquote(repo), opts)
      def update_with_file_keep_previous(changeset, opts \\ []), do: Uploadex.update_with_file_keep_previous(changeset, unquote(repo), opts)
      def delete_with_file(changeset, opts \\ []), do: Uploadex.delete_with_file(changeset, unquote(repo), opts)
    end
  end
end