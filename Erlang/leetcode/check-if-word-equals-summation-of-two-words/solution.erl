-module(solution).
-export([is_sum_equal/3]).
-include("node.hrl").

-spec is_sum_equal(FirstWord :: unicode:unicode_binary(), SecondWord :: unicode:unicode_binary(), TargetWord :: unicode:unicode_binary()) -> boolean().
is_sum_equal(FirstWord, SecondWord, TargetWord) ->
  word_to_num(FirstWord) + word_to_num(SecondWord) == word_to_num(TargetWord).

word_to_num(W) ->
  lists:foldl(fun(C, Num) -> Num * 10 + (C - $a) end, 0, binary_to_list(W)).
