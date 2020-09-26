defmodule MurkyWeb.Component.ListItem do
  use Phoenix.LiveComponent
  alias MurkyWeb.Router.Helpers

  def render(assigns) do
    ~L"""
      <li class="flex border hover:shadow-lg rounded-lg border-l-8 border-primary-200 hover:bg-primary-200 hover:bg-opacity-25 cursor-pointer m-2" phx-click="to-view" phx-value-filename="<%= @filename %>">
        <div class="text-xl p-2"><%= @filename %></div>
        <button class="p-2 hover:bg-primary-200" phx-click="edit-file" phx-value-filename="<%= @filename %>">
          <img class="w-5" src="<%= Helpers.static_path(@socket, "/images/edit-icon.svg") %>"/>
        </button>
        <button class="p-2 hover:bg-alternate-200 rounded-r-lg" phx-click="try-delete-file" phx-value-filename="<%= @filename %>">
          <img class="w-5" src="<%= Helpers.static_path(@socket, "/images/trash-icon.svg") %>"/>
        </button>
      </li>
    """
  end
end
