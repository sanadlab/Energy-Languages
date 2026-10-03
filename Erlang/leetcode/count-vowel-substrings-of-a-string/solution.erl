-module(solution).
-export([count_vowel_substrings/1]).
-include("node.hrl").

-spec count_vowel_substrings(Word :: unicode:unicode_binary()) -> integer().
count_vowel_substrings(Word) ->
  Chars = binary_to_list(Word),
  outer(Chars, 0).

outer([], Acc) -> Acc;
outer([C | T] = L, Acc) ->
  case is_vowel(C) of
    false -> outer(T, Acc);
    true -> outer(T, Acc + inner(L, #{}, 0))
  end.

inner([], _Seen, Acc) -> Acc;
inner([C | T], Seen, Acc) ->
  case is_vowel(C) of
    false -> Acc;
    true ->
      Seen2 = Seen#{C => true},
      Acc2 = case map_size(Seen2) =:= 5 of
               true -> Acc + 1;
               false -> Acc
             end,
      inner(T, Seen2, Acc2)
  end.

is_vowel($a) -> true;
is_vowel($e) -> true;
is_vowel($i) -> true;
is_vowel($o) -> true;
is_vowel($u) -> true;
is_vowel(_) -> false.
