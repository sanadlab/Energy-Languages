-module(solution).
-export([maximum_binary_string/1]).
-include("node.hrl").

-spec maximum_binary_string(Binary :: unicode:unicode_binary()) -> unicode:unicode_binary().
maximum_binary_string(Binary) ->
    L = binary_to_list(Binary),
    case find_zero(L, 0) of
        -1 ->
            Binary;
        First ->
            Zeros = length([C || C <- L, C =:= $0]),
            N = length(L),
            P = First + Zeros - 1,
            list_to_binary([case I =:= P of true -> $0; false -> $1 end
                            || I <- lists:seq(0, N - 1)])
    end.

find_zero([], _I) -> -1;
find_zero([$0 | _], I) -> I;
find_zero([_ | T], I) -> find_zero(T, I + 1).
