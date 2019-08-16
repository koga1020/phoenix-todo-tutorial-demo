defmodule TodoTutorialWeb.Router do
  use TodoTutorialWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug Phoenix.LiveView.Flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TodoTutorialWeb do
    pipe_through :browser

    get "/", PageController, :index
    resources "/tasks", TaskController
  end

  scope "/api", TodoTutorialWeb.Api do
    pipe_through :api

    resources "/tasks", TaskController
  end
end
