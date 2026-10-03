-module(solution).
-export([close_strings/2]).
-include("node.hrl").

-spec close_strings(Word1 :: unicode:unicode_binary(), Word2 :: unicode:unicode_binary()) -> boolean().
close_strings(Word1, Word2) ->
  case byte_size(Word1) == byte_size(Word2) of
      false -> false;
      true ->
          F1 = freq(Word1),
          F2 = freq(Word2),
          SameSet = lists:all(
              fun(I) ->
                  A = element(I, F1),
                  B = element(I, F2),
                  (A == 0) == (B == 0)
              end, lists:seq(1, 26)),
          case SameSet of
              false -> false;
              true -> lists:sort(tuple_to_list(F1)) == lists:sort(tuple_to_list(F2))
          end
  end.

freq(Bin) ->
  lists:foldl(
      fun(C, T) ->
          I = C - $a + 1,
          setelement(I, T, element(I, T) + 1)
      end, erlang:make_tuple(26, 0), binary_to_list(Bin)).
