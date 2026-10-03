-module(solution).
-export([max_size_slices/1]).
-include("node.hrl").

-spec max_size_slices(Slices :: [integer()]) -> integer().
max_size_slices(Slices) ->
    Total = length(Slices),
    K = Total div 3,
    case K of
        0 -> 0;
        _ -> max(best(lists:droplast(Slices), K), best(tl(Slices), K))
    end.

%% Max sum of K non-adjacent elements picked from a line of values.
best(Nums, K) ->
    N = length(Nums),
    NumsT = list_to_tuple(Nums),
    Neg = -1 bsl 60,
    %% Row tuple of size K+1: element(J+1, Row) = dp[i][J]; j=0 is always 0.
    Dp0 = list_to_tuple([0 | [Neg || _ <- lists:seq(1, K)]]),
    {_, DpN} = lists:foldl(
        fun(I, {Prev2, Prev1}) ->
            Num = element(I, NumsT),
            Cells = [best_cell(I, J, Prev2, Prev1, Num, Neg) || J <- lists:seq(1, K)],
            {Prev1, list_to_tuple([0 | Cells])}
        end, {Dp0, Dp0}, lists:seq(1, N)),
    element(K + 1, DpN).

best_cell(I, J, Prev2, Prev1, Num, Neg) ->
    Skip = element(J + 1, Prev1),
    Prev = case I >= 2 of
               true -> element(J, Prev2);
               false -> case J =:= 1 of true -> 0; false -> Neg end
           end,
    max(Skip, Prev + Num).
