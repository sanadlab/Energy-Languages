-module(solution).
-export([maximum_beauty/5]).
-include("node.hrl").

-spec maximum_beauty(Flowers :: [integer()], NewFlowers :: integer(), Target :: integer(), Full :: integer(), Partial :: integer()) -> integer().
maximum_beauty([], _NewFlowers, _Target, _Full, _Partial) ->
    0;
maximum_beauty(Flowers, NewFlowers, Target, Full, Partial) ->
    N = length(Flowers),
    Fl = lists:sort([min(F, Target) || F <- Flowers]),
    FlT = list_to_tuple(Fl),
    PreT = build_pre(Fl),
    case hd(Fl) =:= Target of
        true ->
            Full * N;
        false ->
            PreN = element(N + 1, PreT),
            lists:foldl(fun(I, Ans) ->
                            step(I, N, NewFlowers, Target, Full, Partial, FlT, PreT, PreN, Ans)
                        end, 0, lists:seq(N, 0, -1))
    end.

%% PreT is 1-indexed: element(K+1, PreT) = sum of first K sorted flowers.
build_pre(Fl) ->
    {_, Rev} = lists:foldl(fun(V, {Acc, Ps}) ->
                               Acc1 = Acc + V,
                               {Acc1, [Acc1 | Ps]}
                           end, {0, [0]}, Fl),
    list_to_tuple(lists:reverse(Rev)).

pre(PreT, K) -> element(K + 1, PreT).

step(I, N, NewFlowers, Target, Full, Partial, FlT, PreT, PreN, Ans) ->
    CostComplete = Target * (N - I) - (PreN - pre(PreT, I)),
    case CostComplete > NewFlowers of
        true ->
            Ans;
        false ->
            Rem = NewFlowers - CostComplete,
            case I of
                0 ->
                    max(Ans, Full * (N - I));
                _ ->
                    BestMin = best_min(FlT, PreT, I, Rem, 0, Target - 1, 0),
                    max(Ans, Full * (N - I) + BestMin * Partial)
            end
    end.

best_min(_FlT, _PreT, _I, _Rem, Lo, Hi, Best) when Lo > Hi -> Best;
best_min(FlT, PreT, I, Rem, Lo, Hi, Best) ->
    V = (Lo + Hi) div 2,
    K = bisect_left(FlT, V, 0, I),
    Cost = V * K - pre(PreT, K),
    case Cost =< Rem of
        true -> best_min(FlT, PreT, I, Rem, V + 1, Hi, V);
        false -> best_min(FlT, PreT, I, Rem, Lo, V - 1, Best)
    end.

%% First index in [Lo, Hi) with FlT value >= X (bisect_left over fl[0..i)).
bisect_left(FlT, X, Lo, Hi) when Lo < Hi ->
    Mid = (Lo + Hi) div 2,
    case element(Mid + 1, FlT) < X of
        true -> bisect_left(FlT, X, Mid + 1, Hi);
        false -> bisect_left(FlT, X, Lo, Mid)
    end;
bisect_left(_FlT, _X, Lo, _Hi) -> Lo.
