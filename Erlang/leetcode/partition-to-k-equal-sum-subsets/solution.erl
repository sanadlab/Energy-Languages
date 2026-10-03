-module(solution).
-export([can_partition_k_subsets/2]).
-include("node.hrl").

-spec can_partition_k_subsets(Nums :: [integer()], K :: integer()) -> boolean().
can_partition_k_subsets(Nums, K) ->
  case K =< 0 orelse length(Nums) < K of
    true -> false;
    false ->
      Total = lists:sum(Nums),
      case Total rem K =/= 0 of
        true -> false;
        false ->
          Target = Total div K,
          Sorted = lists:reverse(lists:sort(Nums)),
          case hd(Sorted) > Target of
            true -> false;
            false ->
              N = length(Sorted),
              T = list_to_tuple(Sorted),
              backtrack(K, 0, 0, T, N, Target, 0)
          end
      end
  end.

backtrack(0, _Cur, _Start, _T, _N, _Target, _Used) -> true;
backtrack(K, Cur, Start, T, N, Target, Used) ->
  case Cur == Target of
    true -> backtrack(K - 1, 0, 0, T, N, Target, Used);
    false -> loop(Start, K, Cur, T, N, Target, Used)
  end.

loop(I, _K, _Cur, _T, N, _Target, _Used) when I >= N -> false;
loop(I, K, Cur, T, N, Target, Used) ->
  Ni = element(I + 1, T),
  case (Used band (1 bsl I)) =/= 0 orelse Cur + Ni > Target of
    true -> loop(I + 1, K, Cur, T, N, Target, Used);
    false ->
      Used1 = Used bor (1 bsl I),
      case backtrack(K, Cur + Ni, I + 1, T, N, Target, Used1) of
        true -> true;
        false ->
          case Cur == 0 of
            true -> false;
            false -> loop(I + 1, K, Cur, T, N, Target, Used)
          end
      end
  end.
