defmodule Pluggy.PageLoader do
  require IEx

  alias Pluggy.User
  import Pluggy.Template, only: [srender: 2]
  import Plug.Conn, only: [send_resp: 3]

  def index(conn) do
    # get user if logged in
    session_user = conn.private.plug_session["user_id"]

    current_user =
      case session_user do
        nil -> nil
        _ -> User.get(session_user)
      end

    send_resp(conn, 200, srender("views/index", user: current_user))
  end

  def nt(conn) do
    # get user if logged in
    session_user = conn.private.plug_session["user_id"]

    current_user =
      case session_user do
        nil -> nil
        _ -> User.get(session_user)
      end
      send_resp(conn, 200, srender("admin/new", user: current_user))
  end

  def home(conn) do
    # get user if logged in
    session_user = conn.private.plug_session["user_id"]

    current_user =
      case session_user do
        nil -> nil
        _ -> User.get(session_user)
      end

      send_resp(conn, 200, srender("teacher/home", user: current_user))
  end

  def play(conn), do: send_resp(conn, 200, srender("teacher/play", []))

  def error(conn), do: send_resp(conn, 200, srender("views/error", []))

  defp redirect(conn, url) do
    Plug.Conn.put_resp_header(conn, "location", url) |> send_resp(303, "")
  end
end
