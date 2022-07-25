defmodule MainLayout do
  import Nitroux

  def wrap(content) do
    "<!DOCTYPE html>" <>
      html(
        lang: Gettext.get_locale(Web.Gettext),
        translate: "no",
        html: [
          head([title("phx-boilerplate") | LayoutHelper.header()]),
          content |> body(),
          LayoutHelper.footer()
        ]
      )
  end
end
