defmodule Pluggy.School do
  defstruct(id: nil, name: "")
  alias Pluggy.School
  def to_struct([id, name]) do
    %School{id: id, name: name}
  end
  def to_struct_list(rows) do
    for [id, name] <- rows, do: %School{id: id, name: name}
  end
end
