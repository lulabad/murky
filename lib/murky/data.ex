defmodule Murky.Data do

    @path_for_files "wiki"
    
    def get_md(file_name) do
        File.read!("wiki/" <> file_name)
        |> Earmark.as_html!(%Earmark.Options{code_class_prefix: "lang- language-"})
    end

    def get_files() do
        File.ls!(@path_for_files)
    end

    def create_file(filename) do
        File.touch!(@path_for_files <> "/" <> filename <> ".md")
    end

    def save_file(filename, content) do
        File.write!(@path_for_files <> "/" <> filename, content)
    end
end