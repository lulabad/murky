defmodule MurkyWeb.Helpers.IconHelper do
  @moduledoc """
  Give some icons to be used on templates.
  """
  use Phoenix.HTML
  alias MurkyWeb.Router.Helpers, as: Routes

  def icon_tag(conn, name, opts \\ []) do
    classes = Keyword.get(opts, :class, "") <> " icon"
    content_tag(:svg, class: classes) do
      tag(:use, "xlink:href": Routes.static_path(conn, "/images/icons.svg#" <> name))
    end
  end
end
