defmodule Pluggy.GameController do

  def showG(conn, id) do
    # get user if logged in
    session_user = conn.private.plug_session["user_id"]

    current_user =
      case session_user do
        nil -> nil
        _ -> User.get(session_user)
      end

  Postgrex.query!(DB, "SELECT * FROM groups WHERE id = $1", [id], pool: DBConnection.Poolboy)

  end

end
