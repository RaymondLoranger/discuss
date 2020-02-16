defmodule DiscussWeb.Controllers.Plugs.RequireAuth do
  import DiscussWeb.Router.Helpers, only: [topic_path: 2]
  import Phoenix.Controller, only: [put_flash: 3, redirect: 2]
  import Plug.Conn, only: [halt: 1]

  alias Discuss.Accounts.User
  alias Plug.Conn

  @spec init(Plug.opts()) :: Plug.opts()
  def init(opts), do: opts

  @spec call(Conn.t(), Plug.opts()) :: Conn.t()
  def call(%Conn{assigns: %{user: %User{}}} = conn, _opts), do: conn

  def call(%Conn{assigns: %{user: nil}} = conn, _opts) do
    conn
    |> put_flash(:error, "You must be signed in.")
    |> redirect(to: topic_path(conn, :index))
    |> halt()
  end
end
