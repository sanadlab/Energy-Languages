-module(solution).
-export([can_cross/1]).
-include("node.hrl").

-spec can_cross(Stones :: [integer()]) -> boolean().
can_cross([_, 1 | _] = Stones) -> do_cross(Stones);
can_cross(_) -> false.

do_cross(Stones) ->
  StoneSet = maps:from_list([{S, true} || S <- Stones]),
  Dp0 = maps:from_list([{S, #{}} || S <- Stones]),
  Dp1 = maps:put(1, #{1 => true}, Dp0),
  Dp = lists:foldl(
         fun(Stone, DpAcc) ->
           Ks = maps:keys(maps:get(Stone, DpAcc)),
           lists:foldl(
             fun(K, DpA) ->
               lists:foldl(
                 fun(Step, DpB) ->
                   Tgt = Stone + Step,
                   case Step > 0 andalso maps:is_key(Tgt, StoneSet) of
                     true ->
                       Cur = maps:get(Tgt, DpB),
                       maps:put(Tgt, Cur#{Step => true}, DpB);
                     false -> DpB
                   end
                 end, DpA, [K - 1, K, K + 1])
             end, DpAcc, Ks)
         end, Dp1, Stones),
  Last = lists:last(Stones),
  maps:size(maps:get(Last, Dp)) > 0.
