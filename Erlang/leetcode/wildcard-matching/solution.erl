-module(solution).
-export([is_match/2]).
-include("node.hrl").

-spec is_match(S :: unicode:unicode_binary(), P :: unicode:unicode_binary()) -> boolean().
is_match(S, P) ->
  ST = list_to_tuple(binary_to_list(S)),
  PT = list_to_tuple(binary_to_list(P)),
  M = tuple_size(ST),
  N = tuple_size(PT),
  DP0 = #{{0, 0} => true},
  DP1 = first_row(1, N, PT, DP0),
  DP = rows(1, M, N, ST, PT, DP1),
  g(M, N, DP).

first_row(J, N, _PT, DP) when J > N -> DP;
first_row(J, N, PT, DP) ->
  DP1 = case element(J, PT) =:= $* of
          true -> DP#{{0, J} => g(0, J - 1, DP)};
          false -> DP
        end,
  first_row(J + 1, N, PT, DP1).

rows(I, M, _N, _ST, _PT, DP) when I > M -> DP;
rows(I, M, N, ST, PT, DP) ->
  DP1 = cols(1, I, N, ST, PT, DP),
  rows(I + 1, M, N, ST, PT, DP1).

cols(J, _I, N, _ST, _PT, DP) when J > N -> DP;
cols(J, I, N, ST, PT, DP) ->
  Pc = element(J, PT),
  Sc = element(I, ST),
  Val =
    if
      Pc =:= Sc orelse Pc =:= $? -> g(I - 1, J - 1, DP);
      Pc =:= $* -> g(I - 1, J, DP) orelse g(I, J - 1, DP);
      true -> false
    end,
  cols(J + 1, I, N, ST, PT, DP#{{I, J} => Val}).

g(I, J, DP) -> maps:get({I, J}, DP, false).
