defmodule DiscussWeb.Plugs.RequireAuth do
  # call halt function
  import Plug.Conn
  # call put_flash funcition
  import Phoenix.Controller

  alias DiscussWeb.Router.Helpers, as: Routes

  def init(_params) do
  end

  def call(conn, _params) do
    if conn.assigns[:user] do
      conn
    else
      conn
      |> put_flash(:error, "必須登入!")
      |> redirect(to: Routes.topic_path(conn, :index))
      |> halt()
    end
  end
end
