defmodule DiscussWeb.AuthFallbackController do
  use DiscussWeb, :controller

  alias Ecto.Changeset
  alias Plug.Conn

  @spec call(Conn.t(), tuple) :: Conn.t()
  def call(conn, {:error, %Changeset{action: :insert} = _changeset}) do
    conn
    |> put_flash(:error, "Error signing in!")
    |> redirect(to: topic_path(conn, :index))
  end
end
