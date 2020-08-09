defmodule MurkyWeb.Component.ListItem do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~L"""
      <li class="list-item" phx-click="to-view" phx-value-filename="<%= @filename %>">
        <h3><%= @filename %></h3>
        <button phx-click="try-delete-file" phx-value-filename="<%= @filename %>">
          <img class="list-item__icon" src="<%= MurkyWeb.Router.Helpers.static_path(@socket, "/images/trash-icon.svg") %>"/>
        </button>
      </li>
    """
  end
end
