-module(solution).
-export([eventual_safe_nodes/1]).
-include("node.hrl").

-spec eventual_safe_nodes(Graph :: [[integer()]]) -> [integer()].
eventual_safe_nodes(Graph) ->
  N = length(Graph),
  {Rev, Outdeg} = build(Graph, N),
  Init = [I || I <- lists:seq(0, N - 1), maps:get(I, Outdeg) =:= 0],
  Safe = process(Init, Rev, Outdeg, #{}),
  [I || I <- lists:seq(0, N - 1), maps:get(I, Safe, false)].

build(Graph, N) ->
  Outdeg0 = maps:from_list([{I, 0} || I <- lists:seq(0, N - 1)]),
  build(Graph, 0, N, #{}, Outdeg0).

build([], _U, _N, Rev, Out) -> {Rev, Out};
build([Row | T], U, N, Rev, Out) ->
  {Rev1, Out1} = lists:foldl(
    fun(V, {R, O}) when V >= 0, V < N ->
          {maps:update_with(V, fun(L) -> [U | L] end, [U], R),
           maps:update_with(U, fun(C) -> C + 1 end, 1, O)};
       (_V, Acc) -> Acc
    end, {Rev, Out}, Row),
  build(T, U + 1, N, Rev1, Out1).

process([], _Rev, _Out, Safe) -> Safe;
process([V | Q], Rev, Out, Safe) ->
  Safe1 = Safe#{V => true},
  Us = maps:get(V, Rev, []),
  {Q1, Out1} = lists:foldl(
    fun(U, {Qa, Oa}) ->
      C = maps:get(U, Oa) - 1,
      Oa1 = Oa#{U => C},
      case C =:= 0 of
        true -> {[U | Qa], Oa1};
        false -> {Qa, Oa1}
      end
    end, {Q, Out}, Us),
  process(Q1, Rev, Out1, Safe1).
