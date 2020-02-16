defmodule DiscussWeb.Router do
  use DiscussWeb, :router

  alias DiscussWeb.Controllers.Plugs.SetUser

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug SetUser
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", DiscussWeb do
    # Use the default browser stack
    pipe_through :browser

    # get "/", PageController, :index
    get "/", TopicController, :index
    # get    "/topics"         , TopicController, :index
    # get    "/topics/:id/edit", TopicController, :edit
    # get    "/topics/new"     , TopicController, :new
    # get    "/topics/:id"     , TopicController, :show
    # post   "/topics"         , TopicController, :create
    # patch  "/topics/:id"     , TopicController, :update
    # put    "/topics/:id"     , TopicController, :update
    # delete "/topics/:id"     , TopicController, :delete
    resources "/topics", TopicController

    # topic_path GET    /                DiscussWeb.TopicController :index
    # topic_path GET    /topics          DiscussWeb.TopicController :index
    # topic_path GET    /topics/:id/edit DiscussWeb.TopicController :edit
    # topic_path GET    /topics/new      DiscussWeb.TopicController :new
    # topic_path GET    /topics/:id      DiscussWeb.TopicController :show
    # topic_path POST   /topics          DiscussWeb.TopicController :create
    # topic_path PATCH  /topics/:id      DiscussWeb.TopicController :update
    #            PUT    /topics/:id      DiscussWeb.TopicController :update
    # topic_path DELETE /topics/:id      DiscussWeb.TopicController :delete
  end

  scope "/auth", DiscussWeb do
    pipe_through :browser

    get "/signout", AuthController, :sign_out
    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback

    # auth_path GET /auth/signout            DiscussWeb.AuthController :sign_out
    # auth_path GET /auth/:provider          DiscussWeb.AuthController :request
    # auth_path GET /auth/:provider/callback DiscussWeb.AuthController :callback
  end

  # Other scopes may use custom stacks.
  # scope "/api", DiscussWeb do
  #   pipe_through :api
  # end
end
