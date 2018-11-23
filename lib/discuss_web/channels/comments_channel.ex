defmodule DiscussWeb.CommentsChannel do
  use Phoenix.Channel

  alias Discuss.Accounts.User
  alias Discuss.Postings.{Comment, Topic}
  alias Ecto.Changeset
  alias Phoenix.{Channel, Socket}

  @type handle_in :: {:reply, Channel.reply(), Socket.t()}
  @type join :: {:ok, reply :: map, Socket.t()} | {:error, map}

  @spec join(binary, map, Socket.t()) :: join
  def join("comments:" <> topic_id = _channel_topic, _payload, socket) do
    import Discuss.Postings, only: [get_topic_comments_user!: 1]
    topic = topic_id |> String.to_integer() |> get_topic_comments_user!()
    {:ok, %{comments: topic.comments}, assign(socket, :topic, topic)}
  end

  @spec handle_in(binary, map, Socket.t()) :: handle_in
  def handle_in(
        "comments:add" = _event,
        %{"content" => content} = _payload,
        %Socket{assigns: %{topic: %Topic{} = topic, user_id: user_id}} = socket
      ) do
    import Discuss.Postings, only: [create_comment_user: 3]

    case create_comment_user(topic, %User{id: user_id}, %{content: content}) do
      {:ok, %Comment{} = comment} ->
        broadcast!(socket, "comments:#{topic.id}:new", %{comment: comment})
        {:reply, :ok, socket}

      {:error, %Changeset{} = changeset} ->
        {:reply, {:error, %{errors: changeset}}, socket}
    end
  end
end
