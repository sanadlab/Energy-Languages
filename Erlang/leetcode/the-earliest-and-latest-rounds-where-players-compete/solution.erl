-module(solution).
-export([earliest_and_latest/3]).
-include("node.hrl").

-spec earliest_and_latest(N :: integer(), FirstPlayer :: integer(), SecondPlayer :: integer()) -> [integer()].
earliest_and_latest(N, FirstPlayer, SecondPlayer) ->
    {E, L} = dp(N, FirstPlayer, SecondPlayer),
    [E, L].

dp(M, F0, S0) ->
    {F, S} = case F0 > S0 of true -> {S0, F0}; false -> {F0, S0} end,
    Key = {dp, M, F, S},
    case get(Key) of
        undefined ->
            R = compute_dp(M, F, S),
            put(Key, R),
            R;
        R -> R
    end.

compute_dp(M, F, S) when F + S =:= M + 1 -> {1, 1};
compute_dp(M, F, S) ->
    NewM = (M + 1) div 2,
    Groups0 = [group(P, M, F, S) || P <- lists:seq(1, M div 2)],
    Groups = case M rem 2 of
                 1 -> Groups0 ++ [[(M + 1) div 2]];
                 _ -> Groups0
             end,
    Outcomes = lists:usort([outcome(Combo, F, S) || Combo <- product(Groups)]),
    lists:foldl(
        fun({NF, NS}, {Emin, Lmax}) ->
            {E, L} = dp(NewM, NF, NS),
            {min(Emin, E + 1), max(Lmax, L + 1)}
        end, {1 bsl 30, -1}, Outcomes).

group(P, M, F, S) ->
    Q = M + 1 - P,
    if
        F =:= P orelse F =:= Q -> [F];
        S =:= P orelse S =:= Q -> [S];
        true -> [P, Q]
    end.

outcome(Combo, F, S) ->
    BelowF = length([W || W <- Combo, W < F]),
    BelowS = length([W || W <- Combo, W < S]),
    {BelowF + 1, BelowS + 1}.

product([]) -> [[]];
product([G | Rest]) ->
    Tails = product(Rest),
    [[X | T] || X <- G, T <- Tails].
