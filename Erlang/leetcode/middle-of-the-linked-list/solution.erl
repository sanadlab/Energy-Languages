-module(solution).
-export([middle_node/1]).
-include("node.hrl").

middle_node(Head) -> mid(Head, Head).

mid(Slow, null) -> Slow;
mid(Slow, #list_node{next = null}) -> Slow;
mid(Slow, #list_node{next = #list_node{next = FNN}}) -> mid(Slow#list_node.next, FNN).
