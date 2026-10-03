-module(solution).
-export([largest_magic_square/1]).
-include("node.hrl").

-spec largest_magic_square(Grid :: [[integer()]]) -> integer().
largest_magic_square(Grid) ->
    G = list_to_tuple([list_to_tuple(Row) || Row <- Grid]),
    M = tuple_size(G),
    N = tuple_size(element(1, G)),
    search_k(G, M, N, min(M, N)).

%% Check square sizes from min(m,n) down to 2; return the first magic size.
search_k(_G, _M, _N, K) when K < 2 -> 1;
search_k(G, M, N, K) ->
    case search_i(G, M, N, K, 0) of
        true -> K;
        false -> search_k(G, M, N, K - 1)
    end.

search_i(_G, M, _N, K, I) when I > M - K -> false;
search_i(G, M, N, K, I) ->
    case search_j(G, N, K, I, 0) of
        true -> true;
        false -> search_i(G, M, N, K, I + 1)
    end.

search_j(_G, N, K, _I, J) when J > N - K -> false;
search_j(G, N, K, I, J) ->
    case is_magic(G, I, J, K) of
        true -> true;
        false -> search_j(G, N, K, I, J + 1)
    end.

cell(G, I, J) -> element(J + 1, element(I + 1, G)).

is_magic(G, R, C, K) ->
    Seq = lists:seq(0, K - 1),
    Total = lists:sum([cell(G, R + K - 1, C + J) || J <- Seq]),
    RowsCols =
        lists:all(fun(I) ->
                      RowSum = lists:sum([cell(G, R + I, C + J) || J <- Seq]),
                      ColSum = lists:sum([cell(G, R + J, C + I) || J <- Seq]),
                      RowSum =:= Total andalso ColSum =:= Total
                  end, Seq),
    case RowsCols of
        false -> false;
        true ->
            Diag1 = lists:sum([cell(G, R + I, C + I) || I <- Seq]),
            Diag2 = lists:sum([cell(G, R + K - 1 - I, C + I) || I <- Seq]),
            Diag1 =:= Total andalso Diag2 =:= Total
    end.
