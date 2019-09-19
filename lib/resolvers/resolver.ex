defmodule Uploadex.Resolver do
  @moduledoc """
  Resolver functions to make it easier to use Uploadex with Absinthe.

  ## Example

    In your Absinthe schema, assuming user only has one photo:

      object :user do
        field :photo_url, :string, resolve: &Uploadex.Resolver.get_file_url/3
      end

    If it has many photos:

      object :user do
        field :photos, list_of(:string), resolve: &Uploadex.Resolver.get_files_url/3
      end

    If an object has many files but the field is for a specific one:

      object :company do
        field :logo_url, :string, resolve: fn company, _, _ -> Uploadex.Resolver.get_file_url(company, company.logo) end
      end
  """

  alias Uploadex.Files

  @spec get_file_url(any, any, any) :: {:error, any} | {:ok, any}
  def get_file_url(record, _, _) do
    case Files.get_file_url(record) do
      {:error, error} -> {:error, error}
      file -> {:ok, file}
    end
  end

  @spec get_file_url(any, any) :: {:ok, any}
  def get_file_url(record, file) do
    {:ok, Files.get_file_url(record, file)}
  end

  @spec get_files_url(any, any, any) :: {:ok, [any]}
  def get_files_url(record, _, _) do
    {:ok, Files.get_files_url(record)}
  end

  @spec get_files_url(any, any) :: {:ok, [any]}
  def get_files_url(record, files) do
    {:ok, Files.get_files_url(record, files)}
  end
end
