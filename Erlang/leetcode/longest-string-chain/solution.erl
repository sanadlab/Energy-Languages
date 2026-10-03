-module(solution).
-export([longest_str_chain/1]).
-include("node.hrl").

-spec longest_str_chain(Words :: [unicode:unicode_binary()]) -> integer().
longest_str_chain(Words) ->
    Sorted = lists:sort(fun(A, B) -> byte_size(A) =< byte_size(B) end, Words),
    {_, Best} = lists:foldl(
        fun(W, {Dp, B}) ->
            Cur = word_chain(W, Dp),
            {Dp#{W => Cur}, max(B, Cur)}
        end, {#{}, 1}, Sorted),
    Best.

word_chain(W, Dp) ->
    L = binary_to_list(W),
    N = length(L),
    lists:foldl(
        fun(I, Cur) ->
            Pred = list_to_binary(delete_at(L, I)),
            case maps:find(Pred, Dp) of
                {ok, V} -> max(Cur, V + 1);
                error -> Cur
            end
        end, 1, lists:seq(0, N - 1)).

delete_at(L, I) ->
    {Before, [_ | After]} = lists:split(I, L),
    Before ++ After.
