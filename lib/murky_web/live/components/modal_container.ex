defmodule MurkyWeb.Component.ModalContainer do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~L"""
    <div class="absolute flex inset-0 z-50 bg-gray-700 bg-opacity-25 justify-center items-center" phx-capture-click="<%= @close %>">
      <div class="relative bg-primary-200 p-8 rounded-lg shadow-md border-primary-200 border">
        <%= render_block(@inner_block) %>
      </div>
    </div>
    """
  end
end
