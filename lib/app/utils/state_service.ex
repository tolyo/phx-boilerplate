defmodule StateService do
  def list(name), do: "stateService.go('#{name}')"
  def new(name), do: "stateService.go('#{name}:new')"
  def created(name), do: "(res) => {stateService.go('#{name}:get', {'id': res.id})}"
  def get(name, id), do: "stateService.go('#{name}:get', {'id': #{id}})"
  def edit(name, id), do: "stateService.go('#{name}:edit', {'id': #{id}})"
end
