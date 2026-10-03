-module(solution).
-export([max_run_time/2]).
-include("node.hrl").

-spec max_run_time(N :: integer(), Batteries :: [integer()]) -> integer().
max_run_time(N, Batteries) ->
  Total = lists:sum(Batteries),
  bs(N, Batteries, 0, Total div N).

bs(_N, _B, Lo, Hi) when Lo >= Hi -> Lo;
bs(N, B, Lo, Hi) ->
  Mid = (Lo + Hi + 1) div 2,
  Avail = lists:sum([min(X, Mid) || X <- B]),
  case Avail >= N * Mid of
    true -> bs(N, B, Mid, Hi);
    false -> bs(N, B, Lo, Mid - 1)
  end.
