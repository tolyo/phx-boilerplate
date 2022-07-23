# Global helpers
defmodule Web.ViewHelpers do
  import Phoenix.HTML.Tag

  def json(val) do
    {:ok, body} = Jason.encode(val)
    body |> String.replace("\"", "'")
  end

  @doc """
    Helper for ensuring proper static file resolution
  """
  def image_tag(url, opts \\ []) do
    if MainApplication.prod() do
      img_tag("#{url}", opts)
    else
      img_tag("/lib/web/#{url}", opts)
    end
  end

  @doc """
    Returns path to image only
  """
  def image_path(url) do
    if MainApplication.prod() do
      "#{url}"
    else
      "/lib/web/#{url}"
    end
  end

  def get_script_type() do
    if MainApplication.prod() do
      "text/javascript"
    else
      "module"
    end
  end
end
