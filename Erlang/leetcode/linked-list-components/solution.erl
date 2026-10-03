-module(solution).
-export([num_components/2]).
-include("node.hrl").

%% Definition for singly-linked list.
%%
%% -record(list_node, {val = 0 :: integer(),
%%                     next = null :: 'null' | #list_node{}}).

-spec num_components(Head :: #list_node{} | null, Nums :: [integer()]) -> integer().
num_components(Head, Nums) ->
  Set = lists:foldl(fun(X, S) -> S#{X => true} end, #{}, Nums),
  walk(Head, Set, false, 0).

walk(null, _Set, _Prev, Count) -> Count;
walk(#list_node{val = V, next = Next}, Set, Prev, Count) ->
  Cur = maps:is_key(V, Set),
  Count1 = case Cur andalso not Prev of
             true -> Count + 1;
             false -> Count
           end,
  walk(Next, Set, Cur, Count1).
