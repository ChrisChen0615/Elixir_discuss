defmodule DiscussWeb.TopicController do
  # discuss_web.ex
  use DiscussWeb, :controller

  alias Discuss.Topic
  alias Discuss.Repo

  def index(conn, _params) do
    topics = Repo.all(Topic)
  end

  def new(conn, _params) do
    changeset = Topic.changeset(%Topic{}, %{})

    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"topic" => topic}) do
    changeset = Topic.changeset(%Topic{}, topic)

    case Repo.insert(changeset) do
      {:ok, post} -> IO.inspect(post)
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
