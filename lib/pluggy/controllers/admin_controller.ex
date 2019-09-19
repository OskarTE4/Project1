defmodule Pluggy.AdminController do

  require IEx

  alias Pluggy.User
  alias Pluggy.School
  import Pluggy.Template, only: [srender: 2]
  import Plug.Conn, only: [send_resp: 3]

  def home(conn) do
    # get user if logged in
    session_user = conn.private.plug_session["user_id"]

    current_user =
      case session_user do
        nil -> nil
        _ -> User.get(session_user)
      end
      send_resp(conn, 200, srender("admin/home", user: current_user))
  end

  def nt(conn) do
    # get user if logged in
    session_user = conn.private.plug_session["user_id"]

    current_user =
      case session_user do
        nil -> nil
        _ -> User.get(session_user)
      end

      schools = Postgrex.query!(DB, "SELECT * FROM schools", [], pool: DBConnection.Poolboy)
      schoollist = School.to_struct_list(schools.rows)
      IO.inspect schoollist
      send_resp(conn, 200, srender("admin/new", locals: %{user: current_user, schools: schoollist}))
  end

  def ns(conn) do
    # get user if logged in
    session_user = conn.private.plug_session["user_id"]

    current_user =
      case session_user do
        nil -> nil
        _ -> User.get(session_user)
      end

    send_resp(conn, 200, srender("admin/schools", user: current_user))
  end

  def add_new(conn, params) do
      Postgrex.query!(DB, "INSERT INTO schools (name)
                          VALUES('#{params["name"]}')",
                          [],
                          pool: DBConnection.Poolboy)
      redirect(conn, "/admin/home")
  end

  defp redirect(conn, url),
    do: Plug.Conn.put_resp_header(conn, "location", url) |> send_resp(303, "")

end
