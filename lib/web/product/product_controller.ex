defmodule Web.ProductController do
  use Web, :controller

  @module_schema Depot.Product
  use CrudController
end
