-module(solution).
-export([can_be_typed_words/2]).
-include("node.hrl").

-spec can_be_typed_words(Text :: unicode:unicode_binary(), BrokenLetters :: unicode:unicode_binary()) -> integer().
can_be_typed_words(Text, BrokenLetters) ->
    BL = binary_to_list(BrokenLetters),
    Words = binary:split(Text, <<" ">>, [global]),
    length([W || W <- Words, W =/= <<>>,
            not lists:any(fun(C) -> lists:member(C, BL) end, binary_to_list(W))]).
