-module(solution).
-export([suggested_products/2]).
-include("node.hrl").

-spec suggested_products(Products :: [unicode:unicode_binary()], SearchWord :: unicode:unicode_binary()) -> [[unicode:unicode_binary()]].
suggested_products(Products, SearchWord) ->
    Sorted = lists:sort(Products),
    Chars = binary_to_list(SearchWord),
    {_Prefix, Acc} =
        lists:foldl(fun(Ch, {Prefix, Res}) ->
                        NewPrefix = <<Prefix/binary, Ch>>,
                        Matching = [P || P <- Sorted, starts_with(P, NewPrefix)],
                        Top3 = lists:sublist(Matching, 3),
                        {NewPrefix, [Top3 | Res]}
                    end, {<<>>, []}, Chars),
    lists:reverse(Acc).

starts_with(P, Prefix) ->
    PL = byte_size(Prefix),
    byte_size(P) >= PL andalso binary:part(P, 0, PL) =:= Prefix.
