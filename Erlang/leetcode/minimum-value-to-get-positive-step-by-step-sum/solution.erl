-module(solution).
-export([min_start_value/1]).
-include("node.hrl").

-spec min_start_value(Nums :: [integer()]) -> integer().
min_start_value(Nums) ->
    {_, MinPrefix} = lists:foldl(
        fun(X, {P, MinP}) ->
            P1 = P + X,
            {P1, min(MinP, P1)}
        end, {0, 0}, Nums),
    max(1, 1 - MinPrefix).
