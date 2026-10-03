-module(solution).
-export([check_straight_line/1]).
-include("node.hrl").

-spec check_straight_line(Coordinates :: [[integer()]]) -> boolean().
check_straight_line([[X0, Y0], [X1, Y1] | Rest]) ->
  Dx = X1 - X0,
  Dy = Y1 - Y0,
  check(Rest, X0, Y0, Dx, Dy).

check([], _X0, _Y0, _Dx, _Dy) -> true;
check([[Xi, Yi] | T], X0, Y0, Dx, Dy) ->
  XDiff = Xi - X0,
  YDiff = Yi - Y0,
  case Dx * YDiff =/= Dy * XDiff of
    true -> false;
    false -> check(T, X0, Y0, Dx, Dy)
  end.
