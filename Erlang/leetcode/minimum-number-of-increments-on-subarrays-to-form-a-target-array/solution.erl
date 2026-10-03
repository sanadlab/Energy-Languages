-module(solution).
-export([min_number_operations/1]).
-include("node.hrl").

-spec min_number_operations(Target :: [integer()]) -> integer().
min_number_operations([]) ->
    0;
min_number_operations([H | T]) ->
    {Ans, _} = lists:foldl(fun(X, {Acc, Prev}) ->
                               D = case X > Prev of true -> X - Prev; false -> 0 end,
                               {Acc + D, X}
                           end, {H, H}, T),
    Ans.
