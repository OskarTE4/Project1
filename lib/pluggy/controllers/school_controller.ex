defmodule Pluggy.Schools do
  defstruct(id: nil, name: "")
  alias Pluggy.Schools
  alias Pluggy.User
  import Pluggy.Template, only: [srender: 2]
  import Plug.Conn, only: [send_resp: 3]

  def delete(conn, params) do
    # get user if logged in
    session_user = conn.private.plug_session["user_id"]

    current_user =
      case session_user do
        nil -> nil
        _ -> User.get(session_user)
      end
   school_id = String.to_integer(params["school_id"])
   Postgrex.query!(DB, "DELETE FROM schools WHERE id = $1", [school_id], pool: DBConnection.Poolboy)
   schools = Postgrex.query!(DB, "SELECT * FROM schools", [], pool: DBConnection.Poolboy)
   send_resp(conn, 200, srender("/admin/home", locals: %{user: current_user, schools: schools}))
 end
  def to_struct([id, name]) do
    %Schools{id: id, name: name}
  end
  def to_struct_list(rows) do
    for [id, name] <- rows, do: %Schools{id: id, name: name}
  end
end

