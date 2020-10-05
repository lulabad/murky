defmodule MurkyWeb.Component.Menu do
  use Phoenix.LiveComponent
  alias MurkyWeb.Router.Helpers
  alias Murky.MenuEntry

  def render(assigns) do
    IO.inspect(assigns.entries)
    ~L"""
        <div class="flex border rounded border-primary-200 ">
          <%= for entry <- MenuEntry.all_prominent(assigns.entries) do %>
            <button phx-click="<%= entry.action %>" class="hover:shadow text-primary-200 px-2 border-r border-primary-200 last:border-r-0 hover:bg-primary-200 hover:text-secondary-500"><%= entry.name %></button>
          <% end %>
          <div class="menu  relative">
            <button class="p-1 hover:shadow hover:bg-primary-200 w-8 h-full hover:text-secondary-400 text-primary-200" >
              <svg class="fill-current"
                viewBox="0 0 330 100"
                fill="none" xmlns="http://www.w3.org/2000/svg"
              >
                <circle cx="50" cy="50" r="50" />
                <circle cx="280" cy="50" r="50" />
                <circle cx="165" cy="50" r="50" />
              </svg>
            </button>
            <div class="menu-group absolute hidden shadow right-0 p-1 bg-white flex-col rounded">
              <%= for entry <- assigns.entries do %>
                <button phx-click="<%= entry.action %>" class="group hover:shadow text-primary-200 hover:bg-primary-200 hover:text-secondary-500 p-1 flex">
                  <div class="border-primary-200 group-hover:border-secondary-400 border-r-2 flex p-1 w-6"><img class="" src="<%= entry.icon %>"></div>
                  <div class="px-2"><%= entry.name %></div>
                </button>
              <% end %>
            </div>
          </div>
        </div>
      </div>
    """
  end

end
