defmodule DiscussWeb.Plugs.SetUser do
  import Plug.Conn
  import Phoenix.Controller

  alias Discuss.Repo
  alias Discuss.User

  def init(_params) do
  end

  def call(conn, _params) do
    # get_session from Phoenix.Controller
    user_id = get_session(conn, :user_id)

    cond do
      user = user_id && Repo.get(User, user_id) ->
        # conn.assigns.user => user struct
        assign(conn, :user, user)

      true ->
        assign(conn, :user, nil)
    end
  end
end
