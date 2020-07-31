defmodule Murky.DataTest do
  use ExUnit.Case
  alias Murky.Data

  setup do
    # make sure the STORAGE_PATH exists
    Data.get_storage_path() |> File.mkdir!()

    on_exit(fn ->
      File.rm_rf!(Murky.Data.get_storage_path())
    end)

    :ok
  end

  test "get_storage_path returns env" do
    assert Data.get_storage_path() == System.fetch_env!("STORAGE_PATH")
  end

  test "create file creates a file" do
    assert File.ls!(Data.get_storage_path()) == []

    Data.create_file("file")

    assert File.ls!(Data.get_storage_path()) == ["file.md"]
  end

  test "get files return correct list of files" do
    Data.create_file("file1")
    Data.create_file("file2")

    assert Data.get_files() == ["file1.md", "file2.md"]
  end

  test "save file updates the file content" do
    Data.create_file("file1")
    assert File.read!(Data.get_storage_path() <> "/" <> "file1.md") == ""

    Data.save_file("file1.md", "Homer Simpson")

    assert File.read!(Data.get_storage_path() <> "/" <> "file1.md") == "Homer Simpson"
  end
end
