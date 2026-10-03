defmodule Solution do
  @spec average(salary :: [integer]) :: float
  def average(salary) do
    total = Enum.sum(salary)
    mn = Enum.min(salary)
    mx = Enum.max(salary)
    (total - mn - mx) / (length(salary) - 2)
  end
end
