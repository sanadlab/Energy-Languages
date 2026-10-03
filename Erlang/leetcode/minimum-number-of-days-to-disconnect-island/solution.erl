-module(solution).
-export([min_days/1]).
-include("node.hrl").

-spec min_days(Grid :: [[integer()]]) -> integer().
min_days(Grid) ->
  Rows = length(Grid),
  Cols = length(hd(Grid)),
  GM = to_map(Grid),
  case count_islands(GM, Rows, Cols) of
    1 -> try_one(GM, Rows, Cols, cells(Rows, Cols));
    _ -> 0
  end.

try_one(_GM, _R, _C, []) -> 2;
try_one(GM, R, C, [{I, J} | T]) ->
  case maps:get({I, J}, GM) of
    1 ->
      GM2 = GM#{{I, J} => 0},
      case count_islands(GM2, R, C) of
        1 -> try_one(GM, R, C, T);
        _ -> 1
      end;
    0 -> try_one(GM, R, C, T)
  end.

count_islands(GM, Rows, Cols) ->
  {Count, _Vis} = lists:foldl(
    fun({I, J}, {Cnt, Vis}) ->
      case maps:get({I, J}, GM) =:= 1 andalso not maps:is_key({I, J}, Vis) of
        true ->
          Vis2 = dfs([{I, J}], GM, Rows, Cols, Vis#{{I, J} => true}),
          {Cnt + 1, Vis2};
        false -> {Cnt, Vis}
      end
    end, {0, #{}}, cells(Rows, Cols)),
  Count.

dfs([], _GM, _R, _C, Vis) -> Vis;
dfs([{X, Y} | Stack], GM, R, C, Vis) ->
  {Stack2, Vis2} = lists:foldl(
    fun({NX, NY}, {St, V}) ->
      case NX >= 0 andalso NX < R andalso NY >= 0 andalso NY < C
           andalso maps:get({NX, NY}, GM) =:= 1
           andalso not maps:is_key({NX, NY}, V) of
        true -> {[{NX, NY} | St], V#{{NX, NY} => true}};
        false -> {St, V}
      end
    end, {Stack, Vis}, [{X + 1, Y}, {X - 1, Y}, {X, Y + 1}, {X, Y - 1}]),
  dfs(Stack2, GM, R, C, Vis2).

cells(Rows, Cols) ->
  [{I, J} || I <- lists:seq(0, Rows - 1), J <- lists:seq(0, Cols - 1)].

to_map(Grid) ->
  {_, M} = lists:foldl(
    fun(Row, {I, Acc}) ->
      {_, Acc2} = lists:foldl(
        fun(V, {J, A}) -> {J + 1, A#{{I, J} => V}} end, {0, Acc}, Row),
      {I + 1, Acc2}
    end, {0, #{}}, Grid),
  M.
