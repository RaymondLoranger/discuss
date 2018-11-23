defmodule DiscussWeb.TopicController do
  use DiscussWeb, :controller

  alias Discuss.Accounts.User
  alias Discuss.Postings
  alias Discuss.Postings.Topic
  alias DiscussWeb.Controllers.Plugs.RequireAuth
  alias DiscussWeb.TopicFallbackController
  alias Plug.Conn

  action_fallback TopicFallbackController

  plug RequireAuth when action in [:new, :create, :edit, :update, :delete]
  plug :check_topic_owner when action in [:edit, :update, :delete]

  @spec index(Conn.t(), map) :: Conn.t()
  def index(conn, _params) do
    topics = Postings.list_topics()
    render(conn, "index.html", topics: topics)
  end

  @spec show(Conn.t(), map) :: Conn.t()
  def show(conn, %{"id" => topic_id} = _params) do
    topic = Postings.get_topic!(topic_id)
    render(conn, "show.html", topic: topic)
  end

  @spec new(Conn.t(), map) :: Conn.t()
  def new(conn, _params) do
    changeset = Postings.change_topic(%Topic{})
    render(conn, "new.html", changeset: changeset)
  end

  @spec create(Conn.t(), map) :: Conn.t()
  def create(
        %Conn{assigns: %{user: %User{} = user}} = conn,
        %{"topic" => topic_attrs} = _params
      ) do
    with {:ok, _topic} <- Postings.create_topic(user, topic_attrs) do
      conn
      |> put_flash(:info, "Topic Created")
      |> redirect(to: topic_path(conn, :index))
    end
  end

  @spec edit(Conn.t(), map) :: Conn.t()
  def edit(conn, %{"id" => topic_id} = _params) do
    topic = Postings.get_topic!(topic_id)
    changeset = Postings.change_topic(topic)
    render(conn, "edit.html", changeset: changeset, topic: topic)
  end

  @spec update(Conn.t(), map) :: Conn.t()
  def update(conn, %{"id" => topic_id, "topic" => topic_attrs} = _params) do
    topic = Postings.get_topic!(topic_id)

    with {:ok, _topic} <- Postings.update_topic(topic, topic_attrs) do
      conn
      |> put_flash(:info, "Topic Updated")
      |> redirect(to: topic_path(conn, :index))
    end
  end

  def delete(conn, %{"id" => topic_id} = _params) do
    topic = Postings.get_topic!(topic_id)

    with {:ok, %Topic{}} <- Postings.delete_topic(topic) do
      conn
      |> put_flash(:info, "Topic Deleted")
      |> redirect(to: topic_path(conn, :index))
    end
  end

  ## Private functions

  @spec check_topic_owner(Conn.t(), Plug.opts()) :: Conn.t()
  defp check_topic_owner(conn, _opts) do
    if Postings.get_topic!(conn.params["id"]).user_id == conn.assigns.user.id do
      conn
    else
      conn
      |> put_flash(:error, "Cannot #{conn.private.phoenix_action} this topic.")
      |> redirect(to: topic_path(conn, :index))
      |> halt()
    end
  end
end
