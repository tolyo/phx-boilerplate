defmodule Web.ProductController do
  use Web, :controller
  plug :put_layout, "main_layout.html"
  @module_schema Depot.Product
  use CrudController
end
