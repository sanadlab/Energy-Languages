-module(solution).
-export([num_factored_binary_trees/1]).
-include("node.hrl").

-spec num_factored_binary_trees(Arr :: [integer()]) -> integer().
num_factored_binary_trees(Arr) ->
  Mod = 1000000007,
  Sorted = lists:sort(Arr),
  {Dp, _Prev} = lists:foldl(
      fun(V, {DpAcc, Prev}) ->
          Cnt = lists:foldl(
              fun(A, C) ->
                  case V rem A == 0 of
                      true ->
                          B = V div A,
                          case maps:find(B, DpAcc) of
                              {ok, DB} -> C + maps:get(A, DpAcc) * DB;
                              error -> C
                          end;
                      false -> C
                  end
              end, 1, Prev),
          {DpAcc#{V => Cnt rem Mod}, [V | Prev]}
      end, {#{}, []}, Sorted),
  Total = lists:foldl(fun(X, Acc) -> Acc + X end, 0, maps:values(Dp)),
  Total rem Mod.
