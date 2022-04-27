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
            html: [title("phx-boilerplate") | LayoutHelper.header()]
          }),
          content |> body()
        ]
      })
  end
end
