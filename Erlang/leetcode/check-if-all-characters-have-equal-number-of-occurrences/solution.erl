-module(solution).
-export([are_occurrences_equal/1]).
-include("node.hrl").

-spec are_occurrences_equal(S :: unicode:unicode_binary()) -> boolean().
are_occurrences_equal(S) ->
    Counts = count_bytes(binary_to_list(S), #{}),
    length(lists:usort(maps:values(Counts))) =:= 1.

count_bytes([], M) -> M;
count_bytes([C | T], M) ->
    count_bytes(T, maps:update_with(C, fun(X) -> X + 1 end, 1, M)).
