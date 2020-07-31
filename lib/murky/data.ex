defmodule Murky.Data do
  def get_md(file_name) do
    File.read!(get_storage_path() <> "/" <> file_name)
    |> Earmark.as_html!(%Earmark.Options{code_class_prefix: "lang- language-"})
  end

  def get_files() do
    get_storage_path()
    |> File.ls!()
  end

  def create_file(filename) do
    File.touch!(get_storage_path() <> "/" <> filename <> ".md")
  end

  def save_file(filename, content) do
    File.write!(get_storage_path() <> "/" <> filename, content)
  end

  def get_storage_path() do
    System.fetch_env!("STORAGE_PATH")
  end
end
