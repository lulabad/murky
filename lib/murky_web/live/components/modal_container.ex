defmodule MurkyWeb.Component.ModalContainer do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~L"""
    <div class="absolute flex inset-0 z-50 bg-white justify-center items-center" phx-capture-click="<%= @close %>">
      <div class="relative bg-primary-200 p-12 rounded-lg bg-opacity-25 shadow-md border-primary-200 border">
        <%= @inner_content.([]) %>
      </div>
    </div>
    """
  end
end
