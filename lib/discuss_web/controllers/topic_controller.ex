defmodule DiscussWeb.TopicController do
  # discuss_web.ex
  use DiscussWeb, :controller

  alias Discuss.Topic
  alias Discuss.Repo
  alias DiscussWeb.Router.Helpers, as: Routes

  # 觸發使用plug的方法名稱
  plug DiscussWeb.Plugs.RequireAuth when action in [:new, :create, :edit, :update, :delete]
  plug :check_topic_owner when action in [:update, :edit, :delete]

  def index(conn, _params) do
    # Ecto 處理Repository的lib
    topics = Repo.all(Topic)

    render(conn, "index.html", topics: topics)
  end

  def new(conn, _params) do
    changeset = Topic.changeset(%Topic{}, %{})

    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"topic" => topic}) do
    # conn.assigns[:user]
    # conn.assigns.user
    # 此兩行同意思
    changeset =
      conn.assigns.user
      |> Ecto.build_assoc(:topics)
      |> Topic.changeset(topic)

    case Repo.insert(changeset) do
      {:ok, _post} ->
        conn
        |> put_flash(:info, "Topic Created")
        |> redirect(to: Routes.topic_path(conn, :index))

      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  @spec edit(Plug.Conn.t(), map) :: Plug.Conn.t()
  def edit(conn, %{"id" => topic_id}) do
    topic = Repo.get(Topic, topic_id)
    changeset = Topic.changeset(topic)

    render(conn, "edit.html", changeset: changeset, topic: topic)
  end

  def update(conn, %{"id" => topic_id, "topic" => topic}) do
    old_topic = Repo.get(Topic, topic_id)
    changeset = Topic.changeset(old_topic, topic)

    case Repo.update(changeset) do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic Updated")
        |> redirect(to: Routes.topic_path(conn, :index))

      {:error, changeset} ->
        render(conn, "edit.html", changeset: changeset, topic: old_topic)
    end
  end

  # 原先方法名稱為"delete"，但執行會失敗，改"show"可成功執行刪除
  def show(conn, %{"id" => topic_id}) do
    Repo.get!(Topic, topic_id) |> Repo.delete!()

    conn
    |> put_flash(:info, "Topic Deleted")
    |> redirect(to: Routes.topic_path(conn, :index))
  end

  # def check_topic_owner(conn, _params) do
  #   %{params: %{"id" => topic_id}} = conn

  #   if Repo.get(Topic, topic_id).user_id == conn.assigns.user.id do
  #     conn
  #   else
  #     conn
  #     |> put_flash(:error, "你不能編輯此筆資料!")
  #     |> redirect(to: Routes.topic_path(conn, :index))
  #     |> halt()
  #   end
  # end
  def check_topic_owner(%{params: %{"id" => topic_id}, assigns: %{user: %{id: user_id}}} = conn, _params) do
    cond do
      Repo.get(Topic, topic_id).user_id == user_id -> conn
      true ->
        conn
        |> put_flash(:error, "你不能編輯此筆資料!")
        |> redirect(to: Routes.topic_path(conn, :index))
        |> halt()
    end
  end
end
