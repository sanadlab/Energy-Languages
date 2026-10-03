-module(solution).
-export([num_triplets/2]).
-include("node.hrl").

-spec num_triplets(Nums1 :: [integer()], Nums2 :: [integer()]) -> integer().
num_triplets(Nums1, Nums2) ->
  helper(Nums1, Nums2) + helper(Nums2, Nums1).

helper(A, B) ->
  lists:foldl(fun(X, Cnt) -> Cnt + count_x(X * X, B) end, 0, A).

count_x(T, B) ->
  {Cnt, _Seen} =
    lists:foldl(
      fun(Y, {C, Seen}) ->
        C1 = case T rem Y of
               0 ->
                 Need = T div Y,
                 C + maps:get(Need, Seen, 0);
               _ -> C
             end,
        {C1, maps:update_with(Y, fun(V) -> V + 1 end, 1, Seen)}
      end, {0, #{}}, B),
  Cnt.
