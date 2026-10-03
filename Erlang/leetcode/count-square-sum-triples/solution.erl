-module(solution).
-export([count_triples/1]).
-include("node.hrl").

-spec count_triples(N :: integer()) -> integer().
count_triples(N) ->
    2 * length([ok || A <- lists:seq(1, N), B <- lists:seq(A, N), is_triple(A, B, N)]).

is_triple(A, B, N) ->
    CS = A * A + B * B,
    C = trunc(math:sqrt(CS)),
    C =< N andalso C * C =:= CS.
