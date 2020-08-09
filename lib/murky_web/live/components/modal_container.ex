defmodule MurkyWeb.Component.ModalContainer do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~L"""
    <div class="modal-container" phx-capture-click="<%= @close %>">
      <div class="modal-container__inner">
        <%= @inner_content.([]) %>
      </div>
    </div>
    """
  end
end
