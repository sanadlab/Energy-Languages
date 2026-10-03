-module(solution).
-export([sort_by_bits/1]).
-include("node.hrl").

-spec sort_by_bits(Arr :: [integer()]) -> [integer()].
sort_by_bits(Arr) ->
  lists:sort(fun(A, B) -> {popcount(A), A} =< {popcount(B), B} end, Arr).

popcount(0) -> 0;
popcount(X) -> (X band 1) + popcount(X bsr 1).
