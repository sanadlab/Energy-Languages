-module(solution).
-export([str_without3a3b/2]).
-include("node.hrl").

str_without3a3b(A, B) ->
    Rev = build(A, B, []),
    list_to_binary(lists:reverse(Rev)).

build(A, B, Rev) when A =< 0, B =< 0 -> Rev;
build(A, B, Rev) ->
    WriteA = case Rev of
                 [X, X | _] -> X =:= $b;  %% last two chars equal
                 _ -> A >= B
             end,
    case WriteA of
        true when A =:= 0 -> Rev;
        true -> build(A - 1, B, [$a | Rev]);
        false when B =:= 0 -> Rev;
        false -> build(A, B - 1, [$b | Rev])
    end.
