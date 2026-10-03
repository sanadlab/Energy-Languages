-module(solution).
-export([is_match/2]).
-include("node.hrl").

-spec is_match(S :: unicode:unicode_binary(), P :: unicode:unicode_binary()) -> boolean().
is_match(S, P) ->
  ST = list_to_tuple(binary_to_list(S)),
  PT = list_to_tuple(binary_to_list(P)),
  M = tuple_size(ST),
  N = tuple_size(PT),
  %% dp[i][j]; dp[M][N] = true, dp[i][N] = (i == M) by default, rest false.
  DP0 = #{{M, N} => true},
  DP = fill_i(M, M, N, ST, PT, DP0),
  g(0, 0, DP).

fill_i(I, _M, _N, _ST, _PT, DP) when I < 0 -> DP;
fill_i(I, M, N, ST, PT, DP) ->
  DP1 = fill_j(N - 1, I, M, N, ST, PT, DP),
  fill_i(I - 1, M, N, ST, PT, DP1).

fill_j(J, _I, _M, _N, _ST, _PT, DP) when J < 0 -> DP;
fill_j(J, I, M, N, ST, PT, DP) ->
  First = (I < M) andalso
          (element(J + 1, PT) =:= element(I + 1, ST) orelse element(J + 1, PT) =:= $.),
  Val =
    case (J + 1 < N) andalso (element(J + 2, PT) =:= $*) of
      true ->
        g(I, J + 2, DP) orelse (First andalso g(I + 1, J, DP));
      false ->
        First andalso g(I + 1, J + 1, DP)
    end,
  fill_j(J - 1, I, M, N, ST, PT, DP#{{I, J} => Val}).

g(I, J, DP) -> maps:get({I, J}, DP, false).
