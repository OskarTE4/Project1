defmodule Pluggy.User do
  defstruct(id: nil, username: "")

  alias Pluggy.User

  def get(id) do
    Postgrex.query!(DB, "SELECT id, name FROM teachers WHERE id = $1 LIMIT 1", [id],
      pool: DBConnection.Poolboy
    ).rows
    |> to_struct
  end

  def to_struct([]), do: %User{}
  def to_struct([[id, username]]) do
    %User{id: id, username: username}
  end
end
