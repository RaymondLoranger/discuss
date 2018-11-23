defmodule DiscussWeb.Controllers.Plugs.SetUser do
  import Plug.Conn

  alias Discuss.Accounts
  alias Plug.Conn

  @spec init(Plug.opts()) :: Plug.opts()
  def init(opts), do: opts

  @spec call(Conn.t(), Plug.opts()) :: Conn.t()
  def call(conn, _opts) do
    user_id = get_session(conn, :user_id)
    user = user_id && Accounts.get_user(user_id)
    assign(conn, :user, user)
  end
end
