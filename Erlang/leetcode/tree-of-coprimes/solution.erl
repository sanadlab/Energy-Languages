-module(solution).
-export([get_coprimes/2]).
-include("node.hrl").

-spec get_coprimes(Nums :: [integer()], Edges :: [[integer()]]) -> [integer()].
get_coprimes(Nums, Edges) ->
  case length(Nums) of
    0 -> [];
    N ->
      NumsT = list_to_tuple(Nums),
      Adj = build_adj(Edges, #{}),
      Coprime = build_coprime(),
      Ans = dfs(0, -1, 0, NumsT, Adj, Coprime, #{}, #{}, #{}),
      %% Nodes unreachable from root 0 keep the default -1 (as in the reference).
      [maps:get(I, Ans, -1) || I <- lists:seq(0, N - 1)]
  end.

%% Iterative-equivalent DFS via immutable recursion. The ancestor stacks
%% DS/NS (indexed by VALUE) are passed down with the current node pushed, so
%% siblings never see each other's pushes (implicit pop on return). Ans is the
%% only state threaded across the whole traversal.
dfs(Node, Parent, Depth, NumsT, Adj, Coprime, Ans, DS, NS) ->
  Val = element(Node + 1, NumsT),
  Cvs = element(Val, Coprime),
  {_BestDepth, BestNode} =
    lists:foldl(
      fun(Cv, {BD, BN}) ->
        case maps:get(Cv, DS, []) of
          [] -> {BD, BN};
          [Top | _] when Top > BD ->
            [TopNode | _] = maps:get(Cv, NS),
            {Top, TopNode};
          _ -> {BD, BN}
        end
      end, {-1, -1}, Cvs),
  Ans1 = maps:put(Node, BestNode, Ans),
  DS1 = maps:put(Val, [Depth | maps:get(Val, DS, [])], DS),
  NS1 = maps:put(Val, [Node | maps:get(Val, NS, [])], NS),
  Children = [Nb || Nb <- maps:get(Node, Adj, []), Nb =/= Parent],
  lists:foldl(
    fun(Nb, AccAns) ->
      dfs(Nb, Node, Depth + 1, NumsT, Adj, Coprime, AccAns, DS1, NS1)
    end, Ans1, Children).

build_adj(null, M) -> M;
build_adj([], M) -> M;
build_adj([[U, V] | Rest], M) ->
  M1 = maps:update_with(U, fun(L) -> [V | L] end, [V], M),
  M2 = maps:update_with(V, fun(L) -> [U | L] end, [U], M1),
  build_adj(Rest, M2).

build_coprime() ->
  list_to_tuple([[B || B <- lists:seq(1, 50), gcd(A, B) =:= 1] || A <- lists:seq(1, 50)]).

gcd(A, 0) -> A;
gcd(A, B) -> gcd(B, A rem B).
