-module(solution).
-export([min_area_rect/1]).
-include("node.hrl").

-spec min_area_rect(Points :: [[integer()]]) -> integer().
min_area_rect(Points) ->
  Seen = lists:foldl(fun([X, Y], S) -> S#{X * 50000 + Y => true} end, #{}, Points),
  Best = outer(Points, Seen, infinity),
  case Best of
    infinity -> 0;
    _ -> Best
  end.

outer([], _Seen, Best) -> Best;
outer([P1 | Rest], Seen, Best) ->
  Best1 = inner(P1, Rest, Seen, Best),
  outer(Rest, Seen, Best1).

inner(_P1, [], _Seen, Best) -> Best;
inner([X1, Y1] = P1, [[X2, Y2] | Rest], Seen, Best) ->
  Best1 =
    case X1 =/= X2 andalso Y1 =/= Y2
         andalso maps:is_key(X1 * 50000 + Y2, Seen)
         andalso maps:is_key(X2 * 50000 + Y1, Seen) of
      true ->
        Area = abs(X1 - X2) * abs(Y1 - Y2),
        min_area(Best, Area);
      false -> Best
    end,
  inner(P1, Rest, Seen, Best1).

min_area(infinity, Area) -> Area;
min_area(Best, Area) -> min(Best, Area).
