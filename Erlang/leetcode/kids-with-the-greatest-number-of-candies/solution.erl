-module(solution).
-export([kids_with_candies/2]).
-include("node.hrl").

-spec kids_with_candies(Candies :: [integer()], ExtraCandies :: integer()) -> [boolean()].
kids_with_candies(Candies, ExtraCandies) ->
  Max = lists:max(Candies),
  [ (Kid + ExtraCandies) >= Max || Kid <- Candies ].
