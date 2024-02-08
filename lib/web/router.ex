defmodule Web.Router do
  use Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do

  end

  scope "/mobile", Web do
    pipe_through :api
    get "/_home", MobileController, :home
    options "/_home", MobileController, :options
  end

  scope "/", Web do
    pipe_through :browser

    get "/", HomeController, :index
    get "/_home", HomeController, :home
    get "/_subview", HomeController, :subview
    get "/_subview2", HomeController, :subview2
    get "/hello-html", HelloController, :index
    get "/docs", DocsController, :index
    get "/demo", DemoController, :index
    get "/mobile", MobileController, :index
    get "/hello", HelloController, :greet
    get "/time", HelloController, :time
    get "/typography", HelloController, :typography
    get "/hello/goodbye", HelloController, :goodbye
    get "/hello-nitro", HelloController, :greet_nitro
    get "/ajax", AjaxtestController, :index
    post "/ajax-test/calculate", AjaxtestController, :calculate

    # Products endpoints
    get "/_products", ProductController, :list
    get "/_products/new", ProductController, :new
    get "/_products/:id", ProductController, :get
    post "/products", ProductController, :create
    post "/products/:id", ProductController, :update
    put "/products/:id", ProductController, :edit
    delete "/products/:id", ProductController, :delete

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
