-module(solution).
-export([sum_odd_length_subarrays/1]).
-include("node.hrl").

-spec sum_odd_length_subarrays(Arr :: [integer()]) -> integer().
sum_odd_length_subarrays(Arr) ->
  N = length(Arr),
  {_, Total} = lists:foldl(
    fun(V, {I, Acc}) ->
      Count = ((I + 1) * (N - I) + 1) div 2,
      {I + 1, Acc + Count * V}
    end, {0, 0}, Arr),
  Total.
