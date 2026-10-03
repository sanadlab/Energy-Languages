-module(solution).
-export([k_weakest_rows/2]).
-include("node.hrl").

-spec k_weakest_rows(Mat :: [[integer()]], K :: integer()) -> [integer()].
k_weakest_rows(Mat, K) ->
  Counts = index_sums(Mat, 0, []),
  Sorted = lists:sort(fun({S1, I1}, {S2, I2}) -> {S1, I1} =< {S2, I2} end, Counts),
  [I || {_S, I} <- lists:sublist(Sorted, K)].

index_sums([], _I, Acc) -> lists:reverse(Acc);
index_sums([Row | T], I, Acc) ->
  index_sums(T, I + 1, [{lists:sum(Row), I} | Acc]).
