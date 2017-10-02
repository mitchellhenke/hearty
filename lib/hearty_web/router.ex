defmodule HeartyWeb.Router do
  use HeartyWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", HeartyWeb do
    pipe_through :browser # Use the default browser stack
    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  scope "/api", HeartyWeb do
    pipe_through :api
    get "/:latitude/:longitude", PageController, :query
  end
end
