defmodule Murky.MenuEntry do
  @enforce_keys [:name, :action]
  defstruct [:name, :action, :icon, prominent: false, hide_name: false, attributes: []]

  @type t :: %Murky.MenuEntry{name: String.t(), action: String.t()}

  def all_prominent(data) do
    Enum.filter(data, fn x -> x.prominent end)
  end
end
