-module(solution).
-export([ladder_length/3]).
-include("node.hrl").

-spec ladder_length(BeginWord :: unicode:unicode_binary(), EndWord :: unicode:unicode_binary(), WordList :: [unicode:unicode_binary()]) -> integer().
ladder_length(BeginWord, EndWord, WordList) ->
  WordSet = maps:from_list([{W, true} || W <- WordList]),
  case maps:is_key(EndWord, WordSet) of
    false -> 0;
    true -> bfs([BeginWord], 1, #{BeginWord => true}, EndWord, WordSet)
  end.

bfs([], _Level, _Visited, _End, _Set) -> 0;
bfs(Frontier, Level, Visited, End, Set) ->
  case step(Frontier, Level, Visited, End, Set, []) of
    {found, Res} -> Res;
    {cont, Visited1, Next} -> bfs(Next, Level + 1, Visited1, End, Set)
  end.

%% Process every word in the current frontier, building the next frontier.
step([], _Level, Visited, _End, _Set, Next) -> {cont, Visited, Next};
step([Word | Rest], Level, Visited, End, Set, Next) ->
  case neighbors(binary_to_list(Word), 0, Level, Visited, End, Set, Next) of
    {found, Res} -> {found, Res};
    {cont, Visited1, Next1} -> step(Rest, Level, Visited1, End, Set, Next1)
  end.

%% For each position in the word, try every letter a-z.
neighbors(Chars, I, _Level, Visited, _End, _Set, Next) when I >= length(Chars) ->
  {cont, Visited, Next};
neighbors(Chars, I, Level, Visited, End, Set, Next) ->
  case letters(Chars, I, $a, Level, Visited, End, Set, Next) of
    {found, Res} -> {found, Res};
    {cont, Visited1, Next1} -> neighbors(Chars, I + 1, Level, Visited1, End, Set, Next1)
  end.

letters(_Chars, _I, C, _Level, Visited, _End, _Set, Next) when C > $z ->
  {cont, Visited, Next};
letters(Chars, I, C, Level, Visited, End, Set, Next) ->
  NextWord = list_to_binary(replace_at(Chars, I, C)),
  case NextWord == End of
    true -> {found, Level + 1};
    false ->
      case maps:is_key(NextWord, Set) andalso not maps:is_key(NextWord, Visited) of
        true ->
          letters(Chars, I, C + 1, Level, Visited#{NextWord => true}, End, Set, [NextWord | Next]);
        false ->
          letters(Chars, I, C + 1, Level, Visited, End, Set, Next)
      end
  end.

replace_at([_ | T], 0, C) -> [C | T];
replace_at([H | T], I, C) -> [H | replace_at(T, I - 1, C)].
