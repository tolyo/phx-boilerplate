defmodule LayoutHelper do
  use Nitroux.HtmlTags

  @moduledoc """
    Helper for loading list of CDN libs
  """
  @libs "./lib/web/layout/cdn-libs.json" |> File.read!() |> Jason.decode!()

  @spec get_libs :: [String.t()]
  def get_libs(), do: @libs

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
          %{} -> script(type: "module", src: Map.keys(x) |> List.first())
          _ -> script(src: x)
        end
      end),
      script("""
          window.app = {};
          let EventTarget = EventTargetShim.EventTarget;
      """),

      ### main CSS bundle
      link(
        rel: "stylesheet",
        href: Web.Endpoint |> Web.Router.Helpers.static_path("/lib/web/app.css")
      )
    ]
    |> head()
  end

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
