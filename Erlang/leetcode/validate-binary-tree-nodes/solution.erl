-module(solution).
-export([validate_binary_tree_nodes/3]).
-include("node.hrl").

-spec validate_binary_tree_nodes(N :: integer(), LeftChild :: [integer()], RightChild :: [integer()]) -> boolean().
validate_binary_tree_nodes(N, LeftChild, RightChild) ->
    M = min(length(LeftChild), length(RightChild)),
    LT = list_to_tuple(LeftChild),
    RT = list_to_tuple(RightChild),
    case build_indeg(0, M, N, LT, RT, #{}) of
        error ->
            false;
        Indeg ->
            case find_root(N, Indeg) of
                none -> false;
                error -> false;
                Root ->
                    case dfs([Root], M, LT, RT, #{}, 0) of
                        error -> false;
                        Count -> Count =:= N
                    end
            end
    end.

build_indeg(I, M, _N, _LT, _RT, Indeg) when I >= M ->
    Indeg;
build_indeg(I, M, N, LT, RT, Indeg) ->
    case add_child(element(I + 1, LT), N, Indeg) of
        error ->
            error;
        Indeg1 ->
            case add_child(element(I + 1, RT), N, Indeg1) of
                error -> error;
                Indeg2 -> build_indeg(I + 1, M, N, LT, RT, Indeg2)
            end
    end.

add_child(-1, _N, Indeg) ->
    Indeg;
add_child(C, N, Indeg) ->
    case C < 0 orelse C >= N of
        true ->
            error;
        false ->
            New = maps:get(C, Indeg, 0) + 1,
            case New > 1 of
                true -> error;
                false -> Indeg#{C => New}
            end
    end.

%% Exactly one node with in-degree 0 -> its index; none -> no root; error -> several.
find_root(N, Indeg) ->
    lists:foldl(fun(I, Acc) ->
                    case Acc of
                        error ->
                            error;
                        Root ->
                            case maps:get(I, Indeg, 0) =:= 0 of
                                true ->
                                    case Root of
                                        none -> I;
                                        _ -> error
                                    end;
                                false ->
                                    Root
                            end
                    end
                end, none, lists:seq(0, N - 1)).

dfs([], _M, _LT, _RT, _Vis, Count) ->
    Count;
dfs([Node | Stack], M, LT, RT, Vis, Count) ->
    case maps:get(Node, Vis, false) of
        true ->
            error;
        false ->
            Vis1 = Vis#{Node => true},
            Stack1 =
                case Node < M of
                    true ->
                        S = push_child(element(Node + 1, RT), Stack),
                        push_child(element(Node + 1, LT), S);
                    false ->
                        Stack
                end,
            dfs(Stack1, M, LT, RT, Vis1, Count + 1)
    end.

push_child(-1, Stack) -> Stack;
push_child(C, Stack) -> [C | Stack].
