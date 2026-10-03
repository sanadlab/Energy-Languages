-module(solution).
-export([is_rectangle_overlap/2]).
-include("node.hrl").

-spec is_rectangle_overlap(Rec1 :: [integer()], Rec2 :: [integer()]) -> boolean().
is_rectangle_overlap([A1, B1, A2, B2], [C1, D1, C2, D2]) ->
  A1 < C2 andalso C1 < A2 andalso B1 < D2 andalso D1 < B2.
