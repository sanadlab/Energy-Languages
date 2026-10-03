-module(solution).
-export([license_key_formatting/2]).
-include("node.hrl").

-spec license_key_formatting(S :: unicode:unicode_binary(), K :: integer()) -> unicode:unicode_binary().
license_key_formatting(S, K) ->
  Clean = [upper(C) || C <- binary_to_list(S), C =/= $-],
  Len = length(Clean),
  First = Len rem K,
  {Head, Rest} = lists:split(First, Clean),
  Groups = case Head of
               [] -> chunk(Rest, K);
               _ -> [Head | chunk(Rest, K)]
           end,
  list_to_binary(string:join(Groups, "-")).

upper(C) when C >= $a, C =< $z -> C - 32;
upper(C) -> C.

chunk([], _K) -> [];
chunk(L, K) ->
  {G, Rest} = take(K, L),
  [G | chunk(Rest, K)].

take(0, L) -> {[], L};
take(_, []) -> {[], []};
take(N, [H | T]) ->
  {G, R} = take(N - 1, T),
  {[H | G], R}.
