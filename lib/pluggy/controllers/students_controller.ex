defmodule Pluggy.Students do
  defstruct(id: nil, name: "", group: "", img: nil)
  alias Pluggy.Students
  def to_struct([id, name, group, img]) do
    %Students{id: id, name: name, group: group, img: img}
  end
  def to_struct_list(rows) do
    for [id, name, group, img] <- rows, do:  %Students{id: id, name: name, group: group, img: img}
  end
end
