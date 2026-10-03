defmodule Solution do
  @spec clumsy(n :: integer) :: integer
  def clumsy(n) do
    {stack, _op} =
      Enum.reduce((n - 1)..1//-1, {[n], 0}, fn x, {stack, op} ->
        new_stack =
          case op do
            0 ->
              [h | t] = stack
              [h * x | t]

            1 ->
              [h | t] = stack
              [div(h, x) | t]

            2 ->
              [x | stack]

            3 ->
              [-x | stack]
          end

        {new_stack, rem(op + 1, 4)}
      end)

    Enum.sum(stack)
  end
end
