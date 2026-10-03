-module(solution).
-export([uncommon_from_sentences/2]).
-include("node.hrl").

-spec uncommon_from_sentences(S1 :: unicode:unicode_binary(), S2 :: unicode:unicode_binary()) -> [unicode:unicode_binary()].
uncommon_from_sentences(S1, S2) ->
  Combined = <<S1/binary, " ", S2/binary>>,
  Words = [W || W <- binary:split(Combined, <<" ">>, [global]), W =/= <<>>],
  Counts = lists:foldl(
             fun(W, M) -> maps:update_with(W, fun(C) -> C + 1 end, 1, M) end,
             #{}, Words),
  [W || {W, C} <- maps:to_list(Counts), C == 1].
