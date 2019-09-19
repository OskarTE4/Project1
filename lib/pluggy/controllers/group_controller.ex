defmodule Pluggy.Groups do
  defstruct(id: nil, name: "", school: nil, img: nil)
  alias Pluggy.Groups
  def to_struct([id, name, school, img]) do
    %Groups{id: id, name: name, school: school, img: img}
  end
  def to_struct_list(rows) do
    for [id, name, school, img] <- rows, do:  %Groups{id: id, name: name, school: school, img: img}
  end
end
