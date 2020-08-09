defmodule MurkyWeb.ListItemTest do
  use MurkyWeb.ConnCase
  import Phoenix.LiveViewTest

  test "show the filename", _ do
    assert render_component(MurkyWeb.Component.ListItem, filename: "blub") =~ "blub"
  end
end
