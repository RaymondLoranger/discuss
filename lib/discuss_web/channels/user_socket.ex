defmodule DiscussWeb.UserSocket do
  use Phoenix.Socket

  alias Phoenix.Socket

  channel("comments:*", DiscussWeb.CommentsChannel)

  transport(:websocket, Phoenix.Transports.WebSocket)

  @spec connect(map, Socket.t()) :: {:ok, Socket.t()} | :error
  def connect(%{"token" => token} = _params, socket) do
    case Phoenix.Token.verify(socket, "user salt", token) do
      {:ok, user_id} -> {:ok, assign(socket, :user_id, user_id)}
      {:error, _reason} -> :error
    end
  end

  @spec id(Socket.t()) :: String.t() | nil
  def id(_socket), do: nil
end
