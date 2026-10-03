-module(solution).
-export([mk_average_init_/2, mk_average_add_element/1, mk_average_calculate_mk_average/0]).

mk_average_init_(M, K) ->
    put(mk, {M, K, 0, []}),
    ok.

mk_average_add_element(Num) ->
    {M, K, N, Rev} = get(mk),
    put(mk, {M, K, N + 1, [Num | Rev]}),
    ok.

mk_average_calculate_mk_average() ->
    {M, K, N, Rev} = get(mk),
    case N < M of
        true -> -1;
        false ->
            Last = lists:sort(lists:sublist(Rev, M)),
            Trimmed = lists:sublist(Last, K + 1, M - 2 * K),
            case Trimmed of
                [] -> 0;
                _ -> trunc(lists:sum(Trimmed) / length(Trimmed))
            end
    end.
