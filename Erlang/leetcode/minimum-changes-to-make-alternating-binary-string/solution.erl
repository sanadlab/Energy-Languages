-module(solution).
-export([min_operations/1]).
-include("node.hrl").

-spec min_operations(S :: unicode:unicode_binary()) -> integer().
min_operations(S) ->
  L = binary_to_list(S),
  N = length(L),
  Cnt = count(L, 0, 0),
  min(Cnt, N - Cnt).

count([], _I, Cnt) -> Cnt;
count([C | T], I, Cnt) ->
  Expected = case I rem 2 of 0 -> $0; _ -> $1 end,
  Cnt1 = case C =/= Expected of true -> Cnt + 1; false -> Cnt end,
  count(T, I + 1, Cnt1).
