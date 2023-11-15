defmodule Web.ProductController do
  use Web, :controller

  @table "products"
  @create_validator Web.ProductValidator
  @update_validator Web.ProductValidator

  use CrudController
end
