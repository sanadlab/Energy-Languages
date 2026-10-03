defmodule Solution do
  import Bitwise

  @inf 1_000_000

  @spec min_sessions(tasks :: [integer], session_time :: integer) :: integer
  def min_sessions(tasks, session_time) do
    n = length(tasks)
    full = (1 <<< n) - 1
    tt = List.to_tuple(tasks)

    {sessions, _used} =
      Enum.reduce(0..full//1, {%{0 => 1}, %{0 => 0}}, fn mask, {sessions, used} ->
        sm = Map.get(sessions, mask, @inf)

        if sm == @inf do
          {sessions, used}
        else
          um = Map.get(used, mask, 0)

          Enum.reduce(0..(n - 1)//1, {sessions, used}, fn i, {sess, usd} ->
            bit = 1 <<< i

            if (mask &&& bit) != 0 do
              {sess, usd}
            else
              nm = mask ||| bit
              ti = elem(tt, i)

              {ns, nu} =
                if um + ti <= session_time do
                  {sm, um + ti}
                else
                  {sm + 1, ti}
                end

              cur_s = Map.get(sess, nm, @inf)
              cur_u = Map.get(usd, nm, 0)

              if ns < cur_s or (ns == cur_s and nu < cur_u) do
                {Map.put(sess, nm, ns), Map.put(usd, nm, nu)}
              else
                {sess, usd}
              end
            end
          end)
        end
      end)

    Map.get(sessions, full, @inf)
  end
end
