-module(solution).
-export([array_strings_are_equal/2]).
-include("node.hrl").

-spec array_strings_are_equal(Word1 :: [unicode:unicode_binary()], Word2 :: [unicode:unicode_binary()]) -> boolean().
array_strings_are_equal(Word1, Word2) ->
  iolist_to_binary(Word1) =:= iolist_to_binary(Word2).
