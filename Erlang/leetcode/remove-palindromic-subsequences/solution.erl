-module(solution).
-export([remove_palindrome_sub/1]).
-include("node.hrl").

-spec remove_palindrome_sub(S :: unicode:unicode_binary()) -> integer().
remove_palindrome_sub(<<>>) -> 0;
remove_palindrome_sub(S) ->
    L = binary_to_list(S),
    case L =:= lists:reverse(L) of
        true -> 1;
        false -> 2
    end.
