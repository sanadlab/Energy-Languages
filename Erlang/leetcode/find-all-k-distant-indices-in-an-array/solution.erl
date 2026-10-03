-module(solution).
-export([find_k_distant_indices/3]).
-include("node.hrl").

-spec find_k_distant_indices(Nums :: [integer()], Key :: integer(), K :: integer()) -> [integer()].
find_k_distant_indices(Nums, Key, K) ->
    T = list_to_tuple(Nums),
    N = tuple_size(T),
    Idxs = lists:seq(0, N - 1),
    [I || I <- Idxs,
          lists:any(fun(J) -> abs(I - J) =< K andalso element(J + 1, T) =:= Key end,
                    Idxs)].
