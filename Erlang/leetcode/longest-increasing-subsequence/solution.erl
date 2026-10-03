-module(solution).
-export([length_of_lis/1]).
-include("node.hrl").

-spec length_of_lis(Nums :: [integer()]) -> integer().
length_of_lis(Nums) ->
  %% Patience sorting with binary search (bisect_left), O(n log n).
  %% `tails` is a functional array with a tracked length.
  {_Arr, Len} = lists:foldl(fun step/2, {array:new(), 0}, Nums),
  Len.

step(X, {Arr, Len}) ->
  I = bisect_left(Arr, 0, Len, X),
  case I == Len of
    true -> {array:set(Len, X, Arr), Len + 1};
    false -> {array:set(I, X, Arr), Len}
  end.

%% leftmost index in [Lo, Hi) where array element >= X
bisect_left(_Arr, Lo, Hi, _X) when Lo >= Hi -> Lo;
bisect_left(Arr, Lo, Hi, X) ->
  Mid = (Lo + Hi) div 2,
  case array:get(Mid, Arr) < X of
    true -> bisect_left(Arr, Mid + 1, Hi, X);
    false -> bisect_left(Arr, Lo, Mid, X)
  end.
