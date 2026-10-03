-module(solution).
-export([num_smaller_by_frequency/2]).
-include("node.hrl").

-spec num_smaller_by_frequency(Queries :: [unicode:unicode_binary()], Words :: [unicode:unicode_binary()]) -> [integer()].
num_smaller_by_frequency(Queries, Words) ->
  WordFreqs = lists:sort([f(W) || W <- Words]),
  Arr = list_to_tuple(WordFreqs),
  L = tuple_size(Arr),
  [begin
       Q = f(Query),
       Idx = bsearch(Arr, Q + 1),
       L - Idx
   end || Query <- Queries].

%% f(s) = number of occurrences of the smallest character in s.
f(S) ->
  Bytes = binary_to_list(S),
  Min = lists:min(Bytes),
  length([C || C <- Bytes, C == Min]).

%% Leftmost 0-based index whose value >= Target (count of elements < Target).
bsearch(Arr, Target) ->
  bsearch(Arr, 0, tuple_size(Arr) - 1, Target).

bsearch(_Arr, Left, Right, _Target) when Left > Right -> Left;
bsearch(Arr, Left, Right, Target) ->
  Mid = (Left + Right) div 2,
  case element(Mid + 1, Arr) < Target of
      true -> bsearch(Arr, Mid + 1, Right, Target);
      false -> bsearch(Arr, Left, Mid - 1, Target)
  end.
