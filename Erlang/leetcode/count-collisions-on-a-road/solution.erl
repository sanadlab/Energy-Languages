-module(solution).
-export([count_collisions/1]).
-include("node.hrl").

-spec count_collisions(Directions :: unicode:unicode_binary()) -> integer().
count_collisions(Directions) ->
  L = binary_to_list(Directions),
  %% Leading 'L' cars drive off to the left and never collide.
  L1 = lists:dropwhile(fun(C) -> C =:= $L end, L),
  %% Trailing 'R' cars drive off to the right and never collide.
  L2 = lists:reverse(lists:dropwhile(fun(C) -> C =:= $R end, lists:reverse(L1))),
  %% Every remaining moving car ('L' or 'R') collides exactly once.
  length([C || C <- L2, C =/= $S]).
