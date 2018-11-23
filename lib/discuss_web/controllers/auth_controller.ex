defmodule DiscussWeb.AuthController do
  use DiscussWeb, :controller

  alias Discuss.Accounts
  alias Discuss.Accounts.User
  alias DiscussWeb.AuthFallbackController
  alias Ecto.Changeset
  alias Plug.Conn

  plug Ueberauth

  action_fallback AuthFallbackController

  @spec callback(Conn.t(), map) :: Conn.t()
  def callback(
        %Conn{assigns: %{ueberauth_auth: %Ueberauth.Auth{} = auth}} = conn,
        %{"provider" => provider} = _params
      ) do
    %{token: auth.credentials.token, email: auth.info.email, provider: provider}
    |> sign_in(conn)
  end

  def callback(conn, params) do
    IO.inspect(conn.assigns, label: "===>>> conn.assigns ===>>>")
    IO.inspect(params, label: "===>>> params ===>>>")

    conn
    |> put_flash(:error, "Could not sign on!")
    |> redirect(to: topic_path(conn, :index))
  end

  @spec sign_out(Conn.t(), map) :: Conn.t()
  def sign_out(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> redirect(to: topic_path(conn, :index))
  end

  ## Private functions

  @spec sign_in(map, Conn.t()) :: Conn.t()
  defp sign_in(user_attrs, conn) do
    with {:ok, %User{id: id, email: email} = _user} <-
           create_or_get_user(user_attrs) do
      conn
      |> put_flash(:info, "Welcome back #{user_name(email)}!")
      |> put_session(:user_id, id)
      |> redirect(to: topic_path(conn, :index))
    end
  end

  @spec user_name(String.t()) :: String.t()
  defp user_name(email),
    do: email |> String.split([".", "_", "@"]) |> List.first()

  @spec create_or_get_user(map) :: {:ok, %User{}} | {:error, Changeset.t()}
  defp create_or_get_user(%{email: email} = user_attrs) do
    case Accounts.get_user_by(email: email) do
      nil -> Accounts.create_user(user_attrs)
      user -> {:ok, user}
    end
  end
end
