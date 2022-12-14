defmodule AuthTutorialPhoenixWeb.Router do
  use AuthTutorialPhoenixWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {AuthTutorialPhoenixWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :auth do
    AuthTutorialPhoenix.Guardian.AuthPipeline
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", AuthTutorialPhoenixWeb do
    pipe_through :api
    post "/users", UserController, :register
    post"/session/new", SessionController, :new
    # just added
    get "/user", UserController, :showUserBy
  end

scope "/api", AuthTutorialPhoenixWeb do
  pipe_through [:api, :auth]
  post "/session/refresh", SessionController, :refresh
  post "/session/delete", SessionController, :delete

  # just added
  get "/users", UserController, :index
  put "/user/:id", UserController, :update
  delete "/user/:id", UserController, :delete
end

  # Other s copes may use custom stacks.
  # scope "/api", AuthtutoWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: AuthTutorialPhoenixWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
