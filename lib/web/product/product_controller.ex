defmodule Web.ProductController do
  use Web, :controller
  @table "products"
  @module_schema Product
  use CrudController
end
