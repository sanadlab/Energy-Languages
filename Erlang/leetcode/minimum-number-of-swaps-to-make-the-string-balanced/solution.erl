-module(solution).
-export([min_swaps/1]).
-include("node.hrl").

-spec min_swaps(S :: unicode:unicode_binary()) -> integer().
min_swaps(S) ->
  Open = lists:foldl(
      fun(C, O) ->
          case C of
              $[ -> O + 1;
              _ when O > 0 -> O - 1;
              _ -> O
          end
      end, 0, binary_to_list(S)),
  (Open + 1) div 2.
