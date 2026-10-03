-module(solution).
-export([max_points/1]).
-include("node.hrl").

-spec max_points(Points :: [[integer()]]) -> integer().
max_points(Points) ->
  N = length(Points),
  case N =< 2 of
    true -> N;
    false -> outer(Points, 1)
  end.

outer([_Last], Best) -> Best;
outer([Pi | Rest], Best) ->
  Slopes = count_slopes(Pi, Rest, #{}),
  outer(Rest, max_from(Slopes, Best)).

count_slopes([Xi, Yi], Rest, Map) ->
  lists:foldl(
    fun([Xj, Yj], M) ->
      Dx0 = Xj - Xi,
      Dy0 = Yj - Yi,
      G = gcd(abs(Dx0), abs(Dy0)),
      Dx1 = Dx0 div G,
      Dy1 = Dy0 div G,
      {Dx, Dy} = case (Dx1 < 0) orelse (Dx1 =:= 0 andalso Dy1 < 0) of
                   true -> {-Dx1, -Dy1};
                   false -> {Dx1, Dy1}
                 end,
      maps:update_with({Dx, Dy}, fun(C) -> C + 1 end, 1, M)
    end, Map, Rest).

max_from(Map, Best) ->
  Max = maps:fold(fun(_K, C, Acc) -> max(C, Acc) end, 0, Map),
  max(Best, Max + 1).

gcd(A, 0) -> A;
gcd(A, B) -> gcd(B, A rem B).
