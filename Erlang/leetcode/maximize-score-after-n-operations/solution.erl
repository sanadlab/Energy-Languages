-module(solution).
-export([max_score/1]).
-include("node.hrl").

-spec max_score(Nums :: [integer()]) -> integer().
max_score(Nums) ->
  NumsT = list_to_tuple(Nums),
  M = length(Nums),
  Full = 1 bsl M,
  {_Dp, Best} = lists:foldl(
      fun(Mask, {Dp, Bst}) ->
        case popcount(Mask) of
          Cnt when Cnt band 1 =:= 1 -> {Dp, Bst};
          Cnt ->
            Op = Cnt div 2 + 1,
            Base = maps:get(Mask, Dp, 0),
            iter_i(0, M, Mask, Op, Base, NumsT, Dp, Bst)
        end
      end, {#{}, 0}, lists:seq(0, Full - 1)),
  Best.

iter_i(I, M, _Mask, _Op, _Base, _NumsT, Dp, Best) when I >= M -> {Dp, Best};
iter_i(I, M, Mask, Op, Base, NumsT, Dp, Best) ->
  case (Mask bsr I) band 1 of
    1 -> iter_i(I + 1, M, Mask, Op, Base, NumsT, Dp, Best);
    0 ->
      {Dp1, Best1} = iter_j(I + 1, I, M, Mask, Op, Base, NumsT, Dp, Best),
      iter_i(I + 1, M, Mask, Op, Base, NumsT, Dp1, Best1)
  end.

iter_j(J, _I, M, _Mask, _Op, _Base, _NumsT, Dp, Best) when J >= M -> {Dp, Best};
iter_j(J, I, M, Mask, Op, Base, NumsT, Dp, Best) ->
  case (Mask bsr J) band 1 of
    1 -> iter_j(J + 1, I, M, Mask, Op, Base, NumsT, Dp, Best);
    0 ->
      Nm = Mask bor (1 bsl I) bor (1 bsl J),
      Val = Base + Op * gcd(element(I + 1, NumsT), element(J + 1, NumsT)),
      Cur = maps:get(Nm, Dp, 0),
      case Val > Cur of
        true -> iter_j(J + 1, I, M, Mask, Op, Base, NumsT, maps:put(Nm, Val, Dp), max(Best, Val));
        false -> iter_j(J + 1, I, M, Mask, Op, Base, NumsT, Dp, Best)
      end
  end.

popcount(0) -> 0;
popcount(X) -> (X band 1) + popcount(X bsr 1).

gcd(A, 0) -> A;
gcd(A, B) -> gcd(B, A rem B).
