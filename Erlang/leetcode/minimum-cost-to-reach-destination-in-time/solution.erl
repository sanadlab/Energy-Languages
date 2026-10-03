-module(solution).
-export([min_cost/3]).
-include("node.hrl").

-spec min_cost(MaxTime :: integer(), Edges :: [[integer()]], PassingFees :: [integer()]) -> integer().
min_cost(MaxTime, Edges, PassingFees) ->
    N = length(PassingFees),
    Inf = 1 bsl 29,
    FeesT = list_to_tuple(PassingFees),
    Adj = build_adj(Edges, N),
    Dp0 = #{{0, 0} => element(1, FeesT)},
    {_, Ans} = lists:foldl(
        fun(T, {Dp, A}) -> step_time(T, N, MaxTime, Inf, FeesT, Adj, Dp, A) end,
        {Dp0, Inf}, lists:seq(0, MaxTime)),
    case Ans >= Inf of
        true -> -1;
        false -> Ans
    end.

build_adj(Edges, N) ->
    lists:foldl(
        fun(E, M) ->
            case E of
                [X, Y, W | _] when X >= 0, X < N, Y >= 0, Y < N, W >= 0 ->
                    M1 = maps:update_with(X, fun(L) -> [{Y, W} | L] end, [{Y, W}], M),
                    maps:update_with(Y, fun(L) -> [{X, W} | L] end, [{X, W}], M1);
                _ -> M
            end
        end, #{}, Edges).

step_time(T, N, MaxTime, Inf, FeesT, Adj, Dp, A) ->
    lists:foldl(
        fun(U, {D, Acc}) -> step_node(T, U, N, MaxTime, Inf, FeesT, Adj, D, Acc) end,
        {Dp, A}, lists:seq(0, N - 1)).

step_node(T, U, N, MaxTime, Inf, FeesT, Adj, D, Acc) ->
    case maps:get({T, U}, D, Inf) of
        Cur when Cur >= Inf -> {D, Acc};
        Cur ->
            Acc1 = case U =:= N - 1 andalso Cur < Acc of
                       true -> Cur;
                       false -> Acc
                   end,
            Neighbors = maps:get(U, Adj, []),
            D1 = lists:foldl(
                fun({V, W}, Dm) ->
                    NT = T + W,
                    NewCost = Cur + element(V + 1, FeesT),
                    case NT =< MaxTime andalso NewCost < maps:get({NT, V}, Dm, Inf) of
                        true -> Dm#{{NT, V} => NewCost};
                        false -> Dm
                    end
                end, D, Neighbors),
            {D1, Acc1}
    end.
