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
      meta(%{
        charset: "utf-8"
      }),
      meta(%{
        name: "viewport",
        content: "width=device-width, initial-scale=1, shrink-to-fit=no"
      }),
      meta(%{
        name: "google",
        content: "notranslate"
      }),
      link(%{
        rel: "preconnect",
        href: "https://fonts.gstatic.com"
      }),
      link(%{
        href: "https://fonts.googleapis.com/css2?family=Rubik:wght@400;500;600&display=swap",
        rel: "stylesheet"
      }),
      link(%{
        rel: "shortcut icon",
        href: Web.Router.Helpers.static_path(Web.Endpoint, "/lib/web/favicon.ico"),
        type: "image/x-icon"
      }),

      # https://cheatsheetseries.owasp.org/cheatsheets/Clickjacking_Defense_Cheat_Sheet.html#best-for-now-legacy-browser-frame-breaking-script -->
      style(%{
        id: "clj",
        html: "body{display:none !important;"
      }),
      script(%{
        type: "text/javascript",
        html: """
        if (self === top) {
            var antiClickjack = document.getElementById("clj");
            antiClickjack.parentNode.removeChild(antiClickjack);
        } else {
            top.location = self.location;
        }
        """
      }),
      get_libs() |> Enum.map(&script(%{src: &1})),
      script("""
          window.app = {};
          let EventTarget = EventTargetShim.EventTarget;
      """),

      ### main CSS bundle
      link(%{
        rel: "stylesheet",
        href: static_path(Web.Endpoint, "/dist/app.css")
      }),
      script(%{
        src: static_path(Web.Endpoint, "/dist/app.js")
      })
    ]
  end
end
