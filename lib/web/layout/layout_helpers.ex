defmodule LayoutHelper do
  use Nitroux.HtmlTags

  @moduledoc """
    Helper for loading list of CDN libs
  """
  @libs "./lib/web/layout/cdn-libs.json" |> File.read!() |> Jason.decode!()

  @spec get_libs :: [String.t()]
  def get_libs(), do: @libs

  @spec header() :: [String.t()]
  def header do
    [
      meta(charset: "utf-8"),
      meta(
        name: "viewport",
        content: "width=device-width, initial-scale=1, shrink-to-fit=no"
      ),
      meta(
        name: "google",
        content: "notranslate"
      ),
      link(
        rel: "shortcut icon",
        href: Web.Endpoint |> Web.Router.Helpers.static_path("/lib/web/favicon.ico"),
        type: "image/x-icon"
      ),
      get_libs()
      |> Enum.map(fn x ->
        case x do
          %{} -> script(type: "module", defer: nil, src: Map.keys(x) |> List.first())
          _ -> script(defer: nil, src: x)
        end
      end),
      # TODO figure out how to generate this dynamically
      script("""
          window.app = {};
          window.routes = [
            {
              name: "home",
              url: "/",
              serverPath: "/_home",
            },

            {
              name: "home.subview",
              url: "/",
              serverPath: "/_subview",
            }
          ];
          window.crudRoutes = [{name: "products"}];
      """),

      ### main CSS bundle
      link(
        rel: "stylesheet",
        href: Web.Endpoint |> Web.Router.Helpers.static_path("/lib/web/app.css")
      )
    ]
    |> head()
  end

  @spec footer() :: [String.t()]
  def footer do
    [
      script(
        type: "module",
        src: Web.Endpoint |> Web.Router.Helpers.static_path("/lib/web/app.js")
      ),
      script(
        async: true,
        src: "http://localhost:3000/browser-sync/browser-sync-client.js?v=2.27.10"
      )
    ]
  end
end
