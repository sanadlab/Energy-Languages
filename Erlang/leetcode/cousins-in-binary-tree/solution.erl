-module(solution).
-export([is_cousins/3]).
-include("node.hrl").

%% Definition for a binary tree node.
%%
%% -record(tree_node, {val = 0 :: integer(),
%%                     left = null  :: 'null' | #tree_node{},
%%                     right = null :: 'null' | #tree_node{}}).

-spec is_cousins(Root :: #tree_node{} | null, X :: integer(), Y :: integer()) -> boolean().
is_cousins(Root, X, Y) ->
  {DX, PX, DY, PY} = dfs(Root, null, 0, X, Y, {-1, null, -1, null}),
  DX == DY andalso PX =/= PY.

dfs(null, _Parent, _Depth, _X, _Y, Acc) ->
  Acc;
dfs(#tree_node{val = V, left = L, right = R} = Node, Parent, Depth, X, Y, {DX, PX, DY, PY}) ->
  {DX1, PX1} = if V == X -> {Depth, Parent}; true -> {DX, PX} end,
  {DY1, PY1} = if V == Y -> {Depth, Parent}; true -> {DY, PY} end,
  Acc1 = dfs(L, Node, Depth + 1, X, Y, {DX1, PX1, DY1, PY1}),
  dfs(R, Node, Depth + 1, X, Y, Acc1).
