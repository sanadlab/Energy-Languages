-module(solution).
-export([min_steps/1]).
-include("node.hrl").

-spec min_steps(N :: integer()) -> integer().
min_steps(N) ->
  min_steps(N, 2, 0).

min_steps(N, _D, Res) when N =< 1 -> Res;
min_steps(N, D, Res) when N rem D =:= 0 -> min_steps(N div D, D, Res + D);
min_steps(N, D, Res) -> min_steps(N, D + 1, Res).
