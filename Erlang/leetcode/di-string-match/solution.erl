-module(solution).
-export([di_string_match/1]).
-include("node.hrl").

-spec di_string_match(S :: unicode:unicode_binary()) -> [integer()].
di_string_match(S) ->
  Chars = binary_to_list(S),
  High0 = length(Chars),
  {Rev, Low, _High} =
    lists:foldl(
      fun($I, {Acc, Lo, Hi}) -> {[Lo | Acc], Lo + 1, Hi};
         (_, {Acc, Lo, Hi}) -> {[Hi | Acc], Lo, Hi - 1}
      end, {[], 0, High0}, Chars),
  lists:reverse([Low | Rev]).
