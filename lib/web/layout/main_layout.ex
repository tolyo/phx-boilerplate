defmodule MainLayout do
  import Nitroux

  def wrap(content) do
    "<!DOCTYPE html>" <>
      html(%{
        lang: Gettext.get_locale(Web.Gettext),
        class: "notranslate",
        translate: "no",
        html: [
          head(%{
            html: title("phx-boilerplate")
          }),
          body(%{
            class: "ng-cloak",
            html: content
          })
          # ,
          # script(%{
          #   type: Web.ViewHelpers.get_script_type(),
          #   onload: "app.init()",
          #   src: Web.Router.Helpers.static_path(Web.Endpoint, "/lib/web/main/main.js")
          # }),
          # HeaderHelpers.footer()
        ]
      })
  end
end
