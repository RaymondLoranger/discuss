defmodule DiscussWeb.Controllers.Plugs.RequireAuth do
  import Phoenix.Controller
  import Plug.Conn

  alias Discuss.Accounts.User
  alias DiscussWeb.Router.Helpers
  alias Plug.Conn

  @spec init(Plug.opts()) :: Plug.opts()
  def init(opts), do: opts

  @spec call(Conn.t(), Plug.opts()) :: Conn.t()
  def call(%Conn{assigns: %{user: %User{}}} = conn, _opts), do: conn

  def call(%Conn{assigns: %{user: nil}} = conn, _opts) do
    conn
    |> put_flash(:error, "You must be logged in.")
    |> redirect(to: Helpers.topic_path(conn, :index))
    |> halt()
  end
end
