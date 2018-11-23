defmodule Discuss.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Discuss.Postings.{Comment, Topic}

  @derive {Poison.Encoder, only: [:email]}

  schema "users" do
    field :email, :string
    field :provider, :string
    field :token, :string
    # has_many :topics, Topic, foreign_key: :user_id
    has_many :topics, Topic
    # has_many :comments, Comment, foreign_key: :user_id
    has_many :comments, Comment

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :provider, :token])
    |> validate_required([:email, :provider, :token])
    |> unique_constraint(:email)
  end
end
