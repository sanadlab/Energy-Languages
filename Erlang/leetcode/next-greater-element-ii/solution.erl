-module(solution).
-export([next_greater_elements/1]).
-include("node.hrl").

-spec next_greater_elements(Nums :: [integer()]) -> [integer()].
next_greater_elements(Nums) ->
  case length(Nums) of
    0 -> [];
    N ->
      T = list_to_tuple(Nums),
      Res = loop(0, 2 * N, N, T, [], #{}),
      [maps:get(I, Res, -1) || I <- lists:seq(0, N - 1)]
  end.

loop(I, End, _N, _T, _Stack, Res) when I >= End -> Res;
loop(I, End, N, T, Stack, Res) ->
  Cur = element((I rem N) + 1, T),
  {Stack1, Res1} = pop_smaller(Stack, Cur, T, Res),
  Stack2 = case I < N of
             true -> [I | Stack1];
             false -> Stack1
           end,
  loop(I + 1, End, N, T, Stack2, Res1).

pop_smaller([Top | Rest], Cur, T, Res) when element(Top + 1, T) < Cur ->
  pop_smaller(Rest, Cur, T, Res#{Top => Cur});
pop_smaller(Stack, _Cur, _T, Res) -> {Stack, Res}.
