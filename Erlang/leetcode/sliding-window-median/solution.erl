-module(solution).
-export([median_sliding_window/2]).
-include("node.hrl").

-spec median_sliding_window(Nums :: [integer()], K :: integer()) -> [float()].
median_sliding_window(Nums, K) ->
  N = length(Nums),
  T = list_to_tuple(Nums),
  windows(0, N - K, T, K, []).

windows(I, Last, _T, _K, Acc) when I > Last -> lists:reverse(Acc);
windows(I, Last, T, K, Acc) ->
  W = lists:sort([element(I + J, T) || J <- lists:seq(1, K)]),
  Median = case K rem 2 of
             1 -> float(lists:nth(K div 2 + 1, W));
             0 -> (lists:nth(K div 2, W) + lists:nth(K div 2 + 1, W)) / 2.0
           end,
  windows(I + 1, Last, T, K, [Median | Acc]).
