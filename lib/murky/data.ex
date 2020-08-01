defmodule Murky.Data do
  def get_md(filename) do
    get_storage_path()
    |> Path.join(filename <> ".md")
    |> File.read!()
    |> Earmark.as_html!(%Earmark.Options{code_class_prefix: "lang- language-"})
  end

  def get_raw_md(filename) do
    get_storage_path()
    |> Path.join(filename <> ".md")
    |> File.read!()
  end

  @spec get_files() :: Enum.t()
  def get_files() do
    get_storage_path()
    |> File.ls!()
    |> Enum.map(fn x -> Path.basename(x, ".md") end)
  end

  @spec create_file(String.t()) :: :ok
  def create_file(filename) do
    get_storage_path()
    |> Path.join(filename <> ".md")
    |> File.touch!()

    :ok
  end

  @spec save_file(String.t(), String.t()) :: :ok
  def save_file(filename, content) do
    get_storage_path()
    |> Path.join(filename <> ".md")
    |> File.write!(content)

    :ok
  end

  @spec get_storage_path() :: String.t()
  def get_storage_path() do
    System.fetch_env!("STORAGE_PATH")
  end
end
