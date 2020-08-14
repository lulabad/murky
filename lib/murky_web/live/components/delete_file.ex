defmodule MurkyWeb.Component.DeleteFile do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~L"""
    <div class="confirm-delete">
      <div class="confirm-delete__text">Do you realy want to delete the file <span>'<%= @filename %>'</span>?</div>
      <button phx-click="delete-file" class="btn btn-primary">delete file</button>
      <button phx-click="close-delete-file" class="btn">cancel</button>
    </div>

    """
  end
end
