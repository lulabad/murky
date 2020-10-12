defmodule MurkyWeb.Component.Menu do
  use Phoenix.LiveComponent
  import MurkyWeb.Helpers.IconHelper
  alias Murky.MenuEntry

  def render(assigns) do
    # IO.inspect(assigns.entries)
    hide_three_dots = Enum.count(MenuEntry.all_prominent(assigns.entries)) == Enum.count(assigns.entries)
    ~L"""
        <div class="menu-container flex rounded-lg relative">
          <%= for entry <- MenuEntry.all_prominent(assigns.entries) do %>
            <button
              phx-click="<%= entry.action %>"
              class="prominent hover:shadow text-primary-200 px-2  border-primary-200 hover:bg-primary-200 hover:text-secondary-500 flex <%= if @first_rounded do %> first:rounded-l-lg <% end %><%= if hide_three_dots do %> last:rounded-r-lg <% else %> border-r <% end %>"
              <%= for attr <- entry.attributes do %><%= Enum.at(attr,0) %>="<%= Enum.at(attr,1) %>"<% end %>
            >
              <div class="flex p-1 w-6">
                <%= if entry.icon do %>
                  <%= icon_tag(@socket, entry.icon, class: "w-6 h-6 self-center menu-entry-primary-fill") %>
                <% end %>
              </div>
              <%= if !entry.hide_name do %>
              <div class="self-center px-1"><%= entry.name %></div>
              <% end %>
            </button>
          <% end %>
          <%= if !hide_three_dots do %>
            <div class="menu relative">
              <button class="p-1 hover:shadow hover:bg-primary-200 w-8 h-full hover:text-secondary-400 text-primary-200 rounded-r-lg flex">
              <%= icon_tag(@socket, "three_dots", class: "w-6 h-6 self-center menu-entry-primary-fill") %>
              </button>
              <div class="menu-group absolute hidden shadow right-0 p-1 bg-white flex-col rounded z-50">
                <%= for entry <- assigns.entries do %>
                  <button
                    phx-click="<%= entry.action %>"
                    class="group hover:shadow text-primary-200 hover:bg-primary-200 hover:text-secondary-500 p-1 flex"
                    <%= for attr <- entry.attributes do %>
                      <%= Enum.at(attr,0) %>="<%= Enum.at(attr,1) %>"
                    <% end %>
                  >
                    <div class="border-primary-200 group-hover:border-secondary-400 border-r-2 flex p-1 w-6"><%= if entry.icon do %>
                        <%= icon_tag(@socket, entry.icon, class: "w-6 h-6 self-center menu-entry-primary-fill") %>
                      <% end %></div>
                    <div class="px-2 self-center"><%= entry.name %></div>
                  </button>
                <% end %>
              </div>
            </div>
          <% end %>
        </div>
    """
  end

end
