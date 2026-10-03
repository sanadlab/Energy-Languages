-module(solution).
-export([evaluate/2]).
-include("node.hrl").

-spec evaluate(S :: unicode:unicode_binary(), Knowledge :: [[unicode:unicode_binary()]]) -> unicode:unicode_binary().
evaluate(S, Knowledge) ->
  Dict = maps:from_list([{K, V} || [K, V] <- Knowledge]),
  %% Word is accumulated as a reversed list of bytes.
  Word = scan(binary_to_list(S), Dict, [], []),
  list_to_binary(lists:reverse(Word)).

%% scan(Chars, Dict, Stack, Word) -> final reversed Word
scan([], _Dict, _Stack, Word) -> Word;
scan([$( | T], Dict, Stack, Word) ->
  scan(T, Dict, [Word | Stack], []);
scan([$) | T], Dict, [Prev | Stack], Word) ->
  Key = list_to_binary(lists:reverse(Word)),
  Val = maps:get(Key, Dict, <<"?">>),
  NewWord = lists:reverse(binary_to_list(Val)) ++ Prev,
  scan(T, Dict, Stack, NewWord);
scan([C | T], Dict, Stack, Word) ->
  scan(T, Dict, Stack, [C | Word]).
