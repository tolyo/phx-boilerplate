defmodule CrudBehavior do
  @type t :: module()
  @callback list() :: [any()]
  @callback get(id :: any()) :: any()
  @callback create(attrs :: any()) :: {:ok, any()} | {:error, any()}
  @callback update(model :: any(), attrs :: any()) :: {:ok, any()} | {:error, any()}
  @callback delete(id :: any()) :: :ok | :error
end
