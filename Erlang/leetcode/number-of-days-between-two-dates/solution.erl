-module(solution).
-export([days_between_dates/2]).
-include("node.hrl").

-spec days_between_dates(Date1 :: unicode:unicode_binary(), Date2 :: unicode:unicode_binary()) -> integer().
days_between_dates(Date1, Date2) ->
  abs(days(Date1) - days(Date2)).

days(S) ->
  [Y, M, D] = [binary_to_integer(P) || P <- binary:split(S, <<"-">>, [global])],
  days_from_civil(Y, M, D).

days_from_civil(Y0, M, D) ->
  Y = case M =< 2 of true -> Y0 - 1; false -> Y0 end,
  Era = Y div 400,
  Yoe = Y - Era * 400,
  Doy = (153 * (M + (case M > 2 of true -> -3; false -> 9 end)) + 2) div 5 + D - 1,
  Doe = Yoe * 365 + Yoe div 4 - Yoe div 100 + Doy,
  Era * 146097 + Doe - 719468.
