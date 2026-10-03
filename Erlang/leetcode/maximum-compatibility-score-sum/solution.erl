-module(solution).
-export([max_compatibility_sum/2]).
-include("node.hrl").

-spec max_compatibility_sum(Students :: [[integer()]], Mentors :: [[integer()]]) -> integer().
max_compatibility_sum(Students, Mentors) ->
  M = length(Students),
  case M of
      0 -> 0;
      _ ->
          ST = list_to_tuple([list_to_tuple(R) || R <- Students]),
          MT = list_to_tuple([list_to_tuple(R) || R <- Mentors]),
          N = tuple_size(element(1, ST)),
          Score = build_score(ST, MT, M, N),
          Full = (1 bsl M) - 1,
          Dp = lists:foldl(
              fun(Mask, DpA) ->
                  I = popcount(Mask),
                  case I >= M of
                      true -> DpA;
                      false ->
                          Cur = maps:get(Mask, DpA, 0),
                          lists:foldl(
                              fun(J, DpB) ->
                                  case (Mask bsr J) band 1 of
                                      1 -> DpB;
                                      0 ->
                                          Nm = Mask bor (1 bsl J),
                                          Val = Cur + maps:get({I, J}, Score),
                                          Old = maps:get(Nm, DpB, 0),
                                          case Val > Old of
                                              true -> DpB#{Nm => Val};
                                              false -> DpB
                                          end
                                  end
                              end, DpA, lists:seq(0, M - 1))
                  end
              end, #{0 => 0}, lists:seq(0, Full)),
          maps:get(Full, Dp, 0)
  end.

build_score(ST, MT, M, N) ->
  lists:foldl(
      fun(I, Acc0) ->
          SI = element(I + 1, ST),
          lists:foldl(
              fun(J, Acc1) ->
                  MJ = element(J + 1, MT),
                  Cnt = lists:foldl(
                      fun(K, C) ->
                          case element(K + 1, SI) == element(K + 1, MJ) of
                              true -> C + 1;
                              false -> C
                          end
                      end, 0, lists:seq(0, N - 1)),
                  Acc1#{{I, J} => Cnt}
              end, Acc0, lists:seq(0, M - 1))
      end, #{}, lists:seq(0, M - 1)).

popcount(0) -> 0;
popcount(N) -> (N band 1) + popcount(N bsr 1).
