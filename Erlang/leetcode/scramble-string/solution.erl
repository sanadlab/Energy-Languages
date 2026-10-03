-module(solution).
-export([is_scramble/2]).
-include("node.hrl").

-spec is_scramble(S1 :: unicode:unicode_binary(), S2 :: unicode:unicode_binary()) -> boolean().
is_scramble(S1, S2) when byte_size(S1) =/= byte_size(S2) ->
  false;
is_scramble(S1, S2) ->
  N = byte_size(S1),
  case N of
    0 -> true;
    _ ->
      D = fill(S1, S2, N),
      maps:get({N, 0, 0}, D, false)
  end.

fill(S1, S2, N) ->
  lists:foldl(
    fun(Len, DL) ->
      lists:foldl(
        fun(I, DI) ->
          lists:foldl(
            fun(J, DJ) ->
              V = compute(S1, S2, Len, I, J, DJ),
              maps:put({Len, I, J}, V, DJ)
            end, DI, lists:seq(0, N - Len))
        end, DL, lists:seq(0, N - Len))
    end, #{}, lists:seq(1, N)).

compute(S1, S2, Len, I, J, D) ->
  case seg_eq(S1, S2, I, J, Len) of
    false -> false;
    true when Len == 1 -> true;
    true -> try_split(Len, I, J, D, 1)
  end.

try_split(Len, _I, _J, _D, K) when K >= Len ->
  false;
try_split(Len, I, J, D, K) ->
  A = maps:get({K, I, J}, D, false) andalso maps:get({Len - K, I + K, J + K}, D, false),
  B = maps:get({K, I, J + Len - K}, D, false) andalso maps:get({Len - K, I + K, J}, D, false),
  case A orelse B of
    true -> true;
    false -> try_split(Len, I, J, D, K + 1)
  end.

seg_eq(S1, S2, I, J, Len) ->
  lists:sort(binary_to_list(binary:part(S1, I, Len)))
    == lists:sort(binary_to_list(binary:part(S2, J, Len))).
