-module(solution).
-export([judge_circle/1]).
-include("node.hrl").

-spec judge_circle(Moves :: unicode:unicode_binary()) -> boolean().
judge_circle(Moves) ->
  {X, Y} = walk(Moves, 0, 0),
  X =:= 0 andalso Y =:= 0.

walk(<<>>, X, Y) -> {X, Y};
walk(<<$U, Rest/binary>>, X, Y) -> walk(Rest, X, Y + 1);
walk(<<$D, Rest/binary>>, X, Y) -> walk(Rest, X, Y - 1);
walk(<<$R, Rest/binary>>, X, Y) -> walk(Rest, X + 1, Y);
walk(<<$L, Rest/binary>>, X, Y) -> walk(Rest, X - 1, Y);
walk(<<_, Rest/binary>>, X, Y) -> walk(Rest, X, Y).
