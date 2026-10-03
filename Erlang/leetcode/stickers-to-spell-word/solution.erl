-module(solution).
-export([min_stickers/2]).
-include("node.hrl").

-spec min_stickers(Stickers :: [unicode:unicode_binary()], Target :: unicode:unicode_binary()) -> integer().
min_stickers(Stickers, Target) ->
    T = binary_to_list(Target),
    N = length(T),
    Full = (1 bsl N) - 1,
    Cnts = [sticker_count(binary_to_list(S)) || S <- Stickers],
    TargetArr = list_to_tuple(T),
    Dp0 = #{0 => 0},
    Dp = lists:foldl(fun(State, Dp) ->
                         case maps:get(State, Dp, inf) of
                             inf ->
                                 Dp;
                             Cur ->
                                 lists:foldl(fun(Cnt, DpA) ->
                                                 Nxt = apply_sticker(State, N, TargetArr, Cnt),
                                                 case Cur + 1 < maps:get(Nxt, DpA, inf) of
                                                     true -> DpA#{Nxt => Cur + 1};
                                                     false -> DpA
                                                 end
                                             end, Dp, Cnts)
                         end
                     end, Dp0, lists:seq(0, Full)),
    case maps:get(Full, Dp, inf) of
        inf -> -1;
        V -> V
    end.

%% Map from letter index (0..25) to available count for one sticker.
sticker_count(S) ->
    lists:foldl(fun(Ch, M) ->
                    Idx = Ch - $a,
                    maps:update_with(Idx, fun(X) -> X + 1 end, 1, M)
                end, #{}, S).

%% Greedily cover as many still-missing target letters as the sticker allows.
apply_sticker(State, N, TargetArr, Cnt) ->
    {Nxt, _Avail} =
        lists:foldl(fun(I, {St, Avail}) ->
                        case St band (1 bsl I) =:= 0 of
                            true ->
                                Idx = element(I + 1, TargetArr) - $a,
                                case maps:get(Idx, Avail, 0) > 0 of
                                    true ->
                                        {St bor (1 bsl I),
                                         maps:update_with(Idx, fun(X) -> X - 1 end, Avail)};
                                    false ->
                                        {St, Avail}
                                end;
                            false ->
                                {St, Avail}
                        end
                    end, {State, Cnt}, lists:seq(0, N - 1)),
    Nxt.
