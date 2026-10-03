-module(solution).
-export([slowest_key/2]).
-include("node.hrl").

-spec slowest_key(ReleaseTimes :: [integer()], KeysPressed :: unicode:unicode_binary()) -> binary().
slowest_key(ReleaseTimes, KeysPressed) ->
    [K0 | KRest] = binary_to_list(KeysPressed),
    [RT0 | _] = ReleaseTimes,
    Triples = lists:zip3(tl(ReleaseTimes), lists:droplast(ReleaseTimes), KRest),
    {BestKey, _} = lists:foldl(
        fun({Cur, Prev, Key}, {Best, BestDur}) ->
            Dur = Cur - Prev,
            case Dur > BestDur orelse (Dur =:= BestDur andalso Key > Best) of
                true -> {Key, Dur};
                false -> {Best, BestDur}
            end
        end, {K0, RT0}, Triples),
    <<BestKey>>.
