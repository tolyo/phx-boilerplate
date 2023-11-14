defmodule Web.ProductController do
  use Web, :controller
  @table "products"
  @create_command ProductValidator
  use CrudController
end
