defmodule Murky.MenuEntryTest do
  use ExUnit.Case

  alias Murky.MenuEntry

  test "filter prominent" do
    data = [
      %MenuEntry{name: "a", action: "a"},
      %MenuEntry{name: "b", action: "b", prominent: true},
      %MenuEntry{name: "c", action: "c", prominent: nil},
      %MenuEntry{name: "d", action: "d", prominent: true},
    ]
    result = MenuEntry.all_prominent(data)

    assert Enum.count(result) == 2

  end
end
