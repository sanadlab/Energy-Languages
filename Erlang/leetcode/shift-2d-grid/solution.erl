-module(solution).
-export([shift_grid/2]).
-include("node.hrl").

-spec shift_grid(Grid :: [[integer()]], K :: integer()) -> [[integer()]].
shift_grid(Grid, K) ->
  case Grid of
      [] -> Grid;
      [FirstRow | _] ->
          M = length(Grid),
          N = length(FirstRow),
          case N of
              0 -> Grid;
              _ ->
                  Total = M * N,
                  Kk = K rem Total,
                  FlatT = list_to_tuple(lists:append(Grid)),
                  ResFlat = [element(((P - Kk + Total) rem Total) + 1, FlatT)
                             || P <- lists:seq(0, Total - 1)],
                  reshape(ResFlat, N)
          end
  end.

reshape([], _N) -> [];
reshape(L, N) ->
  {Row, Rest} = lists:split(N, L),
  [Row | reshape(Rest, N)].
