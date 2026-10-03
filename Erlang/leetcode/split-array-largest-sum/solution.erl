-module(solution).
-export([split_array/2]).
-include("node.hrl").

-spec split_array(Nums :: [integer()], K :: integer()) -> integer().
split_array(Nums, K) ->
  Lo = lists:max(Nums),
  Hi = lists:sum(Nums),
  bsearch(Lo, Hi, Nums, K).

bsearch(Lo, Hi, _Nums, _K) when Lo >= Hi ->
  Lo;
bsearch(Lo, Hi, Nums, K) ->
  Mid = (Lo + Hi) div 2,
  case count_parts(Nums, Mid) =< K of
    true -> bsearch(Lo, Mid, Nums, K);
    false -> bsearch(Mid + 1, Hi, Nums, K)
  end.

count_parts(Nums, Mid) ->
  {Cnt, _Cur} =
    lists:foldl(
      fun(X, {C, Cur}) ->
        case Cur + X > Mid of
          true -> {C + 1, X};
          false -> {C, Cur + X}
        end
      end, {1, 0}, Nums),
  Cnt.
