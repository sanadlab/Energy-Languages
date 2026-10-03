-module(solution).
-export([reformat_date/1]).
-include("node.hrl").

-spec reformat_date(Date :: unicode:unicode_binary()) -> unicode:unicode_binary().
reformat_date(Date) ->
    Parts = binary:split(Date, <<" ">>, [global]),
    case length(Parts) < 3 of
        true ->
            <<"">>;
        false ->
            [P0, P1, P2 | _] = Parts,
            P0L = binary_to_list(P0),
            Day0 =
                case length(P0L) >= 2 of
                    true -> lists:sublist(P0L, length(P0L) - 2);
                    false -> P0L
                end,
            Day =
                case length(Day0) =:= 1 of
                    true -> [$0 | Day0];
                    false -> Day0
                end,
            Month = month(P1),
            iolist_to_binary([P2, <<"-">>, Month, <<"-">>, Day])
    end.

month(<<"Jan">>) -> <<"01">>;
month(<<"Feb">>) -> <<"02">>;
month(<<"Mar">>) -> <<"03">>;
month(<<"Apr">>) -> <<"04">>;
month(<<"May">>) -> <<"05">>;
month(<<"Jun">>) -> <<"06">>;
month(<<"Jul">>) -> <<"07">>;
month(<<"Aug">>) -> <<"08">>;
month(<<"Sep">>) -> <<"09">>;
month(<<"Oct">>) -> <<"10">>;
month(<<"Nov">>) -> <<"11">>;
month(<<"Dec">>) -> <<"12">>;
month(_) -> <<"01">>.
