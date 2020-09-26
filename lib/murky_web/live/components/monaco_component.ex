defmodule MurkyWeb.MonacoComponent do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~L"""
    <div class="absolute top-0 left-0 h-full w-full overflow-hidden m-0 p-0"
        phx-hook="MonacoEditor" data-raw="<%= @raw_md %>">
    </div>
    """
  end
end
