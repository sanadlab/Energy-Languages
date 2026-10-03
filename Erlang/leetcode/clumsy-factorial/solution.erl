-module(solution).
-export([clumsy/1]).
-include("node.hrl").

-spec clumsy(N :: integer()) -> integer().
clumsy(N) ->
    Stack = loop(N - 1, 0, [N]),
    lists:sum(Stack).

%% x counts down from n-1 to 1; op cycles 0..3 (*, int(/), +x, -x).
loop(X, _Op, Stack) when X =< 0 -> Stack;
loop(X, Op, Stack) ->
    NewStack =
        case Op of
            0 -> [Top | T] = Stack, [Top * X | T];
            1 -> [Top | T] = Stack, [trunc(Top / X) | T];
            2 -> [X | Stack];
            _ -> [-X | Stack]
        end,
    loop(X - 1, (Op + 1) rem 4, NewStack).
