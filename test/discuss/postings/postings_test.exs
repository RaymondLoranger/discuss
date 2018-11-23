defmodule Discuss.PostingsTest do
  use Discuss.DataCase

  alias Discuss.Postings

  # doctest Postings

  describe "topics" do
    alias Discuss.Accounts.User
    alias Discuss.Postings.Topic

    @valid_attrs %{title: "some title"}
    @update_attrs %{title: "some updated title"}
    @invalid_attrs %{title: nil}

    def topic_fixture(attrs \\ %{}) do
      attrs = Enum.into(attrs, @valid_attrs)
      {:ok, topic} = Postings.create_topic(%User{}, attrs)
      topic
    end

    test "list_topics/0 returns all topics" do
      topic = topic_fixture()
      assert Postings.list_topics() == [topic]
    end

    test "get_topic!/1 returns the topic with given id" do
      topic = topic_fixture()
      assert Postings.get_topic!(topic.id).title == topic.title
    end

    test "create_topic/1 with valid data creates a topic" do
      assert {:ok, %Topic{} = topic} =
               Postings.create_topic(%User{}, @valid_attrs)

      assert topic.title == "some title"
    end

    test "create_topic/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} =
               Postings.create_topic(%User{}, @invalid_attrs)
    end

    test "update_topic/2 with valid data updates the topic" do
      topic = topic_fixture()
      assert {:ok, topic} = Postings.update_topic(topic, @update_attrs)
      assert %Topic{} = topic
      assert topic.title == "some updated title"
    end

    test "update_topic/2 with invalid data returns error changeset" do
      topic = topic_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Postings.update_topic(topic, @invalid_attrs)

      assert topic.title == Postings.get_topic!(topic.id).title
    end

    test "delete_topic/1 deletes the topic" do
      topic = topic_fixture()
      assert {:ok, %Topic{}} = Postings.delete_topic(topic)
      assert_raise Ecto.NoResultsError, fn -> Postings.get_topic!(topic.id) end
    end

    test "change_topic/1 returns a topic changeset" do
      topic = topic_fixture()
      assert %Ecto.Changeset{} = Postings.change_topic(topic)
    end
  end

  describe "comments" do
    alias Discuss.Accounts.User
    alias Discuss.Postings.{Comment, Topic}

    @valid_attrs %{content: "some content"}
    @update_attrs %{content: "some updated content"}
    @invalid_attrs %{content: nil}

    def comment_fixture(attrs \\ %{}) do
      attrs = Enum.into(attrs, @valid_attrs)
      {:ok, comment} = Postings.create_comment(%Topic{}, %User{}, attrs)
      comment
    end

    test "list_comments/0 returns all comments" do
      comment = comment_fixture()
      assert Postings.list_comments() == [comment]
    end

    test "get_comment!/1 returns the comment with given id" do
      comment = comment_fixture()
      assert Postings.get_comment!(comment.id).content == comment.content
    end

    test "create_comment/1 with valid data creates a comment" do
      assert {:ok, %Comment{} = comment} =
               Postings.create_comment(%Topic{}, %User{}, @valid_attrs)

      assert comment.content == "some content"
    end

    test "create_comment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} =
               Postings.create_comment(%Topic{}, %User{}, @invalid_attrs)
    end

    test "update_comment/2 with valid data updates the comment" do
      comment = comment_fixture()
      assert {:ok, comment} = Postings.update_comment(comment, @update_attrs)
      assert %Comment{} = comment
      assert comment.content == "some updated content"
    end

    test "update_comment/2 with invalid data returns error changeset" do
      comment = comment_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Postings.update_comment(comment, @invalid_attrs)

      assert comment.content == Postings.get_comment!(comment.id).content
    end

    test "delete_comment/1 deletes the comment" do
      comment = comment_fixture()
      assert {:ok, %Comment{}} = Postings.delete_comment(comment)

      assert_raise Ecto.NoResultsError, fn ->
        Postings.get_comment!(comment.id)
      end
    end

    test "change_comment/1 returns a comment changeset" do
      comment = comment_fixture()
      assert %Ecto.Changeset{} = Postings.change_comment(comment)
    end
  end
end
