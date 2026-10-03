-module(solution).
-export([num_of_ways/1]).
-include("node.hrl").

-spec num_of_ways(Nums :: [integer()]) -> integer().
num_of_ways(Nums) ->
  Mod = 1000000007,
  N = length(Nums),
  C = pascal(N, Mod),
  (ways(Nums, C, Mod) - 1 + Mod) rem Mod.

%% Binomial table. element(I+1, Rows) is the row for i (a tuple of length i+1,
%% element(J+1) = C[i][j]). Only the lower triangle (j =< i) is stored.
pascal(N, Mod) ->
  {Rows, _} = lists:foldl(
      fun(I, {Acc, PrevRow}) ->
          Row = case I of
                    0 -> {1};
                    _ ->
                        list_to_tuple(
                            [case J of
                                 0 -> 1;
                                 _ when J == I -> element(J, PrevRow);
                                 _ -> (element(J, PrevRow) + element(J + 1, PrevRow)) rem Mod
                             end || J <- lists:seq(0, I)])
                end,
          {[Row | Acc], Row}
      end, {[], undefined}, lists:seq(0, N)),
  list_to_tuple(lists:reverse(Rows)).

ways(Arr, C, Mod) ->
  M = length(Arr),
  case M =< 2 of
      true -> 1;
      false ->
          [Root | Tail] = Arr,
          Left = [X || X <- Tail, X < Root],
          Right = [X || X <- Tail, X > Root],
          RowM1 = element(M, C),
          Comb = element(length(Left) + 1, RowM1),
          ((Comb * ways(Left, C, Mod)) rem Mod * ways(Right, C, Mod)) rem Mod
  end.
