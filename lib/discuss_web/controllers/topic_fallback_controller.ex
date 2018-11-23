defmodule DiscussWeb.TopicFallbackController do
  use DiscussWeb, :controller

  alias Ecto.Changeset
  alias Plug.Conn

  @spec call(Conn.t(), tuple) :: Conn.t()
  def call(conn, {:error, %Changeset{action: :insert} = changeset}) do
    render(conn, "new.html", changeset: changeset)
  end

  def call(conn, {:error, %Changeset{action: :update} = changeset}) do
    render(conn, "edit.html", changeset: changeset, topic: changeset.data)
  end

  def call(conn, {:error, %Changeset{action: :delete} = _changeset}) do
    conn
    |> put_flash(:error, "Topic Not Deleted")
    |> redirect(to: topic_path(conn, :index))
  end
end
