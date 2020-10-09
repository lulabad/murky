defmodule MurkyWeb.MenuTest do
  use MurkyWeb.ConnCase
  import Phoenix.LiveViewTest
  alias MurkyWeb.Component
  alias Murky.MenuEntry

  test "render menu", _ do
    html = render_component(Component.Menu, entries: [])

    assert html
    |> Floki.parse_document!()
    |> Floki.find("div[class~='menu-container']")
    |> Enum.count() == 1

    assert html
    |> Floki.parse_document!()
    |> Floki.find("div[class~='menu-group']")
    |> Enum.count() == 0
  end

  test "render prominent button", _ do
    html = render_component(Component.Menu, first_rounded: false, entries: [
      %MenuEntry{name: "TEST", action: "test-action", prominent: true},
      %MenuEntry{name: "TWO", action: "two-action"},
    ])

    assert html
      |> Floki.parse_document!()
      |> Floki.find("button[class~='prominent']")
      |> Enum.count() == 1

    assert html
      |> Floki.parse_document!()
      |> Floki.find("button[class~='prominent']")
      |> Floki.text() == "TEST"

  end

  test "render only icon", _ do
    html = render_component(Component.Menu, first_rounded: false, entries: [
      %MenuEntry{name: "TEST", action: "test-action", prominent: true, hide_name: true},
    ])

    assert html
    |> Floki.parse_document!()
    |> Floki.find("button[class~='prominent']")
    |> Floki.text() != "TEST"
  end

  test "render icon", _ do
    html = render_component(Component.Menu, first_rounded: false, entries: [
      %MenuEntry{name: "TEST", action: "test-action", prominent: true, icon: "murky.svg"},
    ])

    assert html
    |> Floki.parse_document!()
    |> Floki.find("button[class~='prominent'] svg")
    |> Enum.count() == 1
  end

  test "button has phx-click", _ do
    html = render_component(Component.Menu, entries: [
      %MenuEntry{name: "TEST", action: "test-action"},
    ])

    assert html
    |> Floki.parse_document!()
    |> Floki.find("button[phx-click='test-action']")
    |> Enum.count() == 1

  end

  test "button has additional attributes", _ do
    html = render_component(Component.Menu, entries: [
      %MenuEntry{
        name: "TEST",
        action: "test-action",
        attributes: [["test_attr", "blub"]]
        },
    ])

    assert html
    |> Floki.parse_document!()
    |> Floki.find("button[test_attr='blub']")
    |> Enum.count() == 1

  end
end
