-module(solution).
-export([shuffle/2]).
-include("node.hrl").

shuffle(Nums, _N) ->
    M = length(Nums) div 2,
    {First, Second} = lists:split(M, Nums),
    lists:flatmap(fun({A, B}) -> [A, B] end, lists:zip(First, Second)).
