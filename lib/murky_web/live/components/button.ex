defmodule MurkyWeb.Component.Button do
  use Phoenix.LiveComponent

  def render(assigns) do
    col = color(assigns)

    ~L"""
      <button phx-click="<%= @action %>"
        class="hover:shadow bg-opacity-75 rounded <%= col %> hover:<%= col %> text-secondary-500 uppercase px-2">
        <%= @text %>
      </button>
    """
  end

  defp color(%{primary: true}) do
    "bg-alternate-300"
  end

  defp color(_) do
    "bg-primary-200"
  end
end
