defmodule Discuss.Postings.Topic do
  use Ecto.Schema
  import Ecto.Changeset

  alias Discuss.Accounts.User
  alias Discuss.Postings.Comment

  schema "topics" do
    field :title, :string
    # belongs_to :user, User, foreign_key: :user_id
    belongs_to :user, User
    # has_many :comments, Comment, foreign_key: :topic_id
    has_many :comments, Comment

    timestamps()
  end

  @doc false
  def changeset(topic, attrs) do
    topic
    |> cast(attrs, [:title])
    |> validate_required([:title])
    |> validate_length(:title, min: 4)
    |> unique_constraint(:title)
  end
end
