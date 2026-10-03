-module(solution).
-export([restore_array/1]).
-include("node.hrl").

-spec restore_array(AdjacentPairs :: [[integer()]]) -> [integer()].
restore_array(AdjacentPairs) ->
  Adj = build_adj(AdjacentPairs, #{}),
  N = length(AdjacentPairs) + 1,
  Start = find_start(maps:keys(Adj), Adj),
  walk(Start, Start, false, Adj, N, 1, [Start]).

build_adj([], Adj) -> Adj;
build_adj([[U, V] | T], Adj) ->
  Adj1 = maps:update_with(U, fun(L) -> [V | L] end, [V], Adj),
  Adj2 = maps:update_with(V, fun(L) -> [U | L] end, [U], Adj1),
  build_adj(T, Adj2).

find_start([K | T], Adj) ->
  case length(maps:get(K, Adj)) of
    1 -> K;
    _ -> find_start(T, Adj)
  end;
find_start([], _Adj) -> 0.

walk(_Cur, _Prev, _HasPrev, _Adj, N, Count, Acc) when Count >= N ->
  lists:reverse(Acc);
walk(Cur, Prev, HasPrev, Adj, N, Count, Acc) ->
  case pick_next(maps:get(Cur, Adj), Prev, HasPrev) of
    none -> lists:reverse(Acc);
    {ok, Nxt} -> walk(Nxt, Cur, true, Adj, N, Count + 1, [Nxt | Acc])
  end.

pick_next([], _Prev, _HasPrev) -> none;
pick_next([X | T], Prev, HasPrev) ->
  case (not HasPrev) orelse (X =/= Prev) of
    true -> {ok, X};
    false -> pick_next(T, Prev, HasPrev)
  end.
