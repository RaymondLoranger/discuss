defmodule Discuss.Postings.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  alias Discuss.Accounts.User
  alias Discuss.Postings.Topic

  @derive {Poison.Encoder, only: [:content, :user]}

  schema "comments" do
    field(:content, :string)
    # belongs_to :user, User, foreign_key: :user_id
    belongs_to(:user, User)
    # belongs_to :topic, Topic, foreign_key: :topic_id
    belongs_to(:topic, Topic)

    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:content])
    |> validate_required([:content])
    |> unique_constraint(:content)
  end
end
