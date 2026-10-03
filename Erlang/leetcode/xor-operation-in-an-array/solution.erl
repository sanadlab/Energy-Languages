-module(solution).
-export([xor_operation/2]).

xor_operation(N, Start) ->
    lists:foldl(fun(I, Acc) -> Acc bxor (Start + 2 * I) end, 0, lists:seq(0, N - 1)).
