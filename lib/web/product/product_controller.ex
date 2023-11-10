defmodule Web.ProductController do
  use Web, :controller
  @table "product"
  @module_schema Product
  use CrudController
end
