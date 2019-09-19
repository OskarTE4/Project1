defmodule Pluggy.UserController do
  # import Pluggy.Template, only: [render: 2]
  import Plug.Conn, only: [send_resp: 3]

  def login(conn, params) do
    username = params["username"]
    pwd = params["pwd"]
    admin = check_admin(username)
    if admin.rows != [] do
      id = Enum.at(admin.rows, 0) |> Enum.at(0)
      password = Enum.at(admin.rows, 0) |> Enum.at(2)
      if password == pwd do
        Plug.Conn.put_session(conn, :user_id, id)
        |> redirect("/admin/home")
      else
        redirect(conn, "/error")
      end
    else
      result =
          Postgrex.query!(DB, "SELECT * FROM teachers WHERE name = $1", [username],
          pool: DBConnection.Poolboy
          )
      case result.num_rows do
        # no user with that username
        0 ->
          redirect(conn, "/error")

        # user with that username exists
        _ ->
          id = Enum.at(result.rows, 0) |> Enum.at(0)
          password = Enum.at(result.rows, 0) |> Enum.at(2)
          # make sure password is correct
          if password == pwd do
            Plug.Conn.put_session(conn, :user_id, id)
            |> redirect("/teacher/home")
          else
            redirect(conn, "/error")
          end
      end
    end
  end
  def logout(conn) do
    Plug.Conn.configure_session(conn, drop: true)
    |> redirect("/")
  end

  defp redirect(conn, url),
    do: Plug.Conn.put_resp_header(conn, "location", url) |> send_resp(303, "")

  def check_admin(username) do
    Postgrex.query!(DB, "SELECT * FROM admin WHERE name = $1", [username], pool: DBConnection.Poolboy)
  end
end
