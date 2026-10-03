-module(solution).
-export([max_sum_two_no_overlap/3]).
-include("node.hrl").

-spec max_sum_two_no_overlap(Nums :: [integer()], FirstLen :: integer(), SecondLen :: integer()) -> integer().
max_sum_two_no_overlap(Nums, FirstLen, SecondLen) ->
  N = length(Nums),
  Pre = build_pre(Nums),
  max(best(Pre, N, FirstLen, SecondLen), best(Pre, N, SecondLen, FirstLen)).

build_pre(Nums) ->
  {_, Rev} = lists:foldl(fun(X, {Acc, L}) -> A2 = Acc + X, {A2, [A2 | L]} end, {0, [0]}, Nums),
  list_to_tuple(lists:reverse(Rev)).

best(Pre, N, L, M) ->
  best_loop(L + M, N, L, M, Pre, 0, 0).

best_loop(I, N, _L, _M, _Pre, Res, _MaxL) when I > N ->
  Res;
best_loop(I, N, L, M, Pre, Res, MaxL) ->
  MaxL1 = max(MaxL, p(Pre, I - M) - p(Pre, I - M - L)),
  Res1 = max(Res, MaxL1 + p(Pre, I) - p(Pre, I - M)),
  best_loop(I + 1, N, L, M, Pre, Res1, MaxL1).

p(Pre, Idx) -> element(Idx + 1, Pre).
