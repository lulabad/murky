defmodule MurkyWeb.MonacoComponent do
    use Phoenix.LiveComponent

    def render(assigns) do
        ~L"""
        <div id="container" 
            class="edit-container__raw_md" 
            phx-hook="MonacoEditor" data-raw="<%= @raw_md %>">
        </div>
        """
      end
end