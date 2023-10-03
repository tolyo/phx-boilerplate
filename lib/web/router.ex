defmodule Web.Router do
  use Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Web do
    pipe_through :browser

    get "/", HomeController, :index
    get "/_home", HomeController, :home
    get "/_subview", HomeController, :subview
    get "/hello-html", HelloController, :index
    get "/hello", HelloController, :greet
    get "/hello/goodbye", HelloController, :goodbye
    get "/hello-nitro", HelloController, :greet_nitro

    # Products endpoints
    get "/_products", ProductController, :list
    get "/_products/new", ProductController, :new
    get "/_products/:id", ProductController, :get
    get "/_products/edit/:id", ProductController, :edit
    get "/products/delete/:id", ProductController, :delete
    post "/products", ProductController, :create
    post "/products/:id", ProductController, :update

    get "/*path", HomeController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", Web do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  # if Mix.env() in [:dev, :test] do
  #   import Phoenix.LiveDashboard.Router

  #   scope "/" do
  #     pipe_through :browser
  #     live_dashboard "/dashboard", metrics: Web.Telemetry
  #   end
  # end

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
