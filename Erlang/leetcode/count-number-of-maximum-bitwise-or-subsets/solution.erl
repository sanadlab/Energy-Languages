-module(solution).
-export([count_max_or_subsets/1]).
-include("node.hrl").

-spec count_max_or_subsets(Nums :: [integer()]) -> integer().
count_max_or_subsets(Nums) ->
  MaxOr = lists:foldl(fun(X, A) -> X bor A end, 0, Nums),
  N = length(Nums),
  T = list_to_tuple(Nums),
  masks(1, 1 bsl N, T, N, MaxOr, 0).

masks(Mask, End, _T, _N, _MaxOr, Count) when Mask >= End -> Count;
masks(Mask, End, T, N, MaxOr, Count) ->
  Cur = or_bits(Mask, 0, N, T, 0),
  Count1 = case Cur == MaxOr of true -> Count + 1; false -> Count end,
  masks(Mask + 1, End, T, N, MaxOr, Count1).

or_bits(_Mask, I, N, _T, Cur) when I >= N -> Cur;
or_bits(Mask, I, N, T, Cur) ->
  Cur1 = case Mask band (1 bsl I) of
           0 -> Cur;
           _ -> Cur bor element(I + 1, T)
         end,
  or_bits(Mask, I + 1, N, T, Cur1).
