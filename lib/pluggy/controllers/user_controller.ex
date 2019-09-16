defmodule Pluggy.UserController do
  # import Pluggy.Template, only: [render: 2]
  import Plug.Conn, only: [send_resp: 3]

  def login(conn, params) do
    username = params["username"]
    pwd = params["pwd"]

    result =
      Postgrex.query!(DB, "SELECT id, password FROM teacher WHERE username = $1", [username],
        pool: DBConnection.Poolboy
      )

    case result.num_rows do
      # no user with that username
      0 ->
        redirect(conn, "/")

      # user with that username exists
      _ ->
        [[id, password]] = result.rows

        # make sure password is correct
        if pwd == result[0][password] do
          Plug.Conn.put_session(conn, :user_id, id)
          |> redirect("/")
        else
          redirect(conn, "/")
        end
    end
  end

  def logout(conn) do
    Plug.Conn.configure_session(conn, drop: true)
    |> redirect("/")
  end

 

  defp redirect(conn, url),
    do: Plug.Conn.put_resp_header(conn, "location", url) |> send_resp(303, "")
end
