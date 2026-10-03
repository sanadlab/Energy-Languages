-module(solution).
-export([min_subsequence/1]).
-include("node.hrl").

-spec min_subsequence(Nums :: [integer()]) -> [integer()].
min_subsequence(Nums) ->
  Sorted = lists:reverse(lists:sort(Nums)),
  Total = lists:sum(Nums),
  take(Sorted, Total, 0, []).

take([], _Total, _Running, Acc) -> lists:reverse(Acc);
take([X | T], Total, Running, Acc) ->
  Running1 = Running + X,
  Acc1 = [X | Acc],
  case Running1 * 2 > Total of
    true -> lists:reverse(Acc1);
    false -> take(T, Total, Running1, Acc1)
  end.
