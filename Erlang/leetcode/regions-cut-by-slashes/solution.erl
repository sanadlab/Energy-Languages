-module(solution).
-export([regions_by_slashes/1]).
-include("node.hrl").

-spec regions_by_slashes(Grid :: [unicode:unicode_binary()]) -> integer().
regions_by_slashes(Grid) ->
  N = length(Grid),
  Total = 4 * N * N,
  P0 = maps:from_list([{I, I} || I <- lists:seq(0, Total - 1)]),
  GT = list_to_tuple(Grid),
  P = lists:foldl(
      fun(R, Pr) ->
          Row = element(R + 1, GT),
          lists:foldl(
              fun(Col, Pc) ->
                  Base = 4 * (R * N + Col),
                  Top = Base,
                  Right = Base + 1,
                  Bottom = Base + 2,
                  Left = Base + 3,
                  Ch = case Col < byte_size(Row) of
                           true -> binary:at(Row, Col);
                           false -> $\s
                       end,
                  Pc1 = case Ch of
                            $/ -> union(Right, Bottom, union(Top, Left, Pc));
                            $\\ -> union(Left, Bottom, union(Top, Right, Pc));
                            _ -> union(Bottom, Left, union(Right, Bottom, union(Top, Right, Pc)))
                        end,
                  Pc2 = case Col + 1 < N of
                            true -> union(Right, 4 * (R * N + Col + 1) + 3, Pc1);
                            false -> Pc1
                        end,
                  case R + 1 < N of
                      true -> union(Bottom, 4 * ((R + 1) * N + Col), Pc2);
                      false -> Pc2
                  end
              end, Pr, lists:seq(0, N - 1))
      end, P0, lists:seq(0, N - 1)),
  {Count, _} = lists:foldl(
      fun(I, {Cnt, Pacc}) ->
          {Ri, Pacc2} = find(I, Pacc),
          case Ri == I of
              true -> {Cnt + 1, Pacc2};
              false -> {Cnt, Pacc2}
          end
      end, {0, P}, lists:seq(0, Total - 1)),
  Count.

find(X, P) ->
  case maps:get(X, P) of
      X -> {X, P};
      PX ->
          GP = maps:get(PX, P),
          find(GP, P#{X => GP})
  end.

union(A, B, P) ->
  {RA, P1} = find(A, P),
  {RB, P2} = find(B, P1),
  case RA =/= RB of
      true -> P2#{RA => RB};
      false -> P2
  end.
