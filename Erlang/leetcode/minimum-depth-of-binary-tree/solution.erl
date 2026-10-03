-module(solution).
-export([min_depth/1]).
-include("node.hrl").

min_depth(null) -> 0;
min_depth(Root) -> bfs([Root], 1).

%% Level-order BFS: return the depth of the first level that contains a leaf.
bfs(Level, Depth) ->
  case lists:any(fun(#tree_node{left = null, right = null}) -> true;
                    (_) -> false
                 end, Level) of
    true -> Depth;
    false ->
      Next = lists:flatmap(fun(#tree_node{left = L, right = R}) ->
                             [C || C <- [L, R], C =/= null]
                           end, Level),
      bfs(Next, Depth + 1)
  end.
