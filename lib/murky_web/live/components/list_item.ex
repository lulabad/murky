defmodule MurkyWeb.Component.ListItem do
  use Phoenix.LiveComponent
  alias MurkyWeb.Component
  alias Murky.MenuEntry

  def buttons(assigns) do
    [
      %MenuEntry{
        name: "Edit",
        action: "edit-file",
        prominent: true,
        icon: "edit",
        hide_name: true,
        attributes: [["phx-value-filename",assigns.filename]]
      },
      %MenuEntry{
        name: "Delete",
        action: "try-delete-file",
        icon: "trash",
        attributes: [["phx-value-filename",assigns.filename]]
      }
    ]
  end

  def render(assigns) do
    ~L"""
      <li class="flex border hover:shadow-lg rounded-lg border-l-8 border-primary-200 hover:bg-primary-200 hover:bg-opacity-25 cursor-pointer m-2" phx-click="to-view" phx-value-filename="<%= @filename %>">
        <div class="text-xl p-2"><%= @filename %></div>
        <%= live_component @socket, Component.Menu, entries: buttons(assigns) , first_rounded: false %>
      </li>
    """
  end
end
