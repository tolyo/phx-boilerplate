defmodule Web.ProductController do
  use Web, :controller

  @module_schema Product
  use CrudController
end
