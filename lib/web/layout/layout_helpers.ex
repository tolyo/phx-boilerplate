defmodule LayoutHelper do
  import Nitroux
  import Web.Router.Helpers

  @moduledoc """
    Helper for loading list of CDN libs
  """
  @libs "./lib/web/shared/shared.json" |> File.read!() |> Jason.decode!()

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
      # link(
      #   rel: "preconnect",
      #   href: "https://fonts.gstatic.com"
      # ),
      # link(
      #   href: "https://fonts.googleapis.com/css2?family=Rubik:wght@400;500;600&display=swap",
      #   rel: "stylesheet"
      # ),
      link(
        rel: "shortcut icon",
        href: Web.Router.Helpers.static_path(Web.Endpoint, "/lib/web/favicon.ico"),
        type: "image/x-icon"
      ),
      get_libs() |> Enum.map(&script(src: &1)),
      script("""
          window.app = {};
          let EventTarget = EventTargetShim.EventTarget;
      """),

      ### Bootstrap
      link(
        href: "https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css",
        rel: "stylesheet",
        integrity: "sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN",
        crossorigin: "anonymous"
      ),

      ### main CSS bundle
      link(
        rel: "stylesheet",
        href: static_path(Web.Endpoint, "/dist/app.css")
      )
    ]
  end

  def footer do
    [
      script(src: static_path(Web.Endpoint, "/dist/app.js"))
    ]
  end
end
