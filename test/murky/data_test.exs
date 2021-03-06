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

  test "create file creates a file" do
    assert File.ls!(Data.get_storage_path()) == []

    Data.create_file("file")

    assert File.ls!(Data.get_storage_path()) == ["file.md"]
  end

  test "get files return correct list of files" do
    Data.create_file("file1")
    Data.create_file("file2")

    assert Data.get_files() -- ["file1", "file2"] == []
  end

  test "list only md files" do
    Data.create_file("file1")

    Data.get_storage_path()
    |> Path.join("wrong-file.txt")
    |> File.touch!()

    assert Data.get_files() == ["file1"]
  end

  test "save file updates the file content" do
    Data.create_file("file1")

    assert Data.get_storage_path()
           |> Path.join("file1.md")
           |> File.read!() == ""

    Data.save_file("file1", "Homer Simpson")

    assert Data.get_storage_path()
           |> Path.join("file1.md")
           |> File.read!() == "Homer Simpson"
  end

  test "get_raw_md returns the corrent file content" do
    filename = "first"
    Data.create_file(filename)
    assert Data.get_raw_md(filename) == ""

    Data.save_file(filename, "Marge Simpson")
    assert Data.get_raw_md(filename) == "Marge Simpson"
  end

  test "delete successful a file" do
    filename = "first"
    Data.create_file(filename)
    assert Data.get_files() == ["first"]

    Data.delete_file(filename)

    assert Data.get_files() == []
  end

  test "error while deleting non existing file" do
    filename = "first"

    assert_raise File.Error, fn ->
      Data.delete_file(filename)
    end
  end

  test "empty filename is not valid" do
    refute Data.filename_valid?("")
  end

  test "simple filename is valid" do
    assert Data.filename_valid?("ddd")
  end

  test "to long filename is not valid" do
    refute Data.filename_valid?(String.duplicate("a", 300))
  end

  test "filename with not supported chars is not valid" do
    refute Data.filename_valid?("d:")
  end
end
