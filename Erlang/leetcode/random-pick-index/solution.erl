-module(solution).
-export([solution_init_/1, solution_pick/1]).
-include("node.hrl").

-spec solution_init_(Nums :: [integer()]) -> any().
solution_init_(Nums) ->
  put(rpi_nums, Nums),
  ok.

-spec solution_pick(Target :: integer()) -> integer().
solution_pick(Target) ->
  %% Reservoir sampling: scan the WHOLE array, roll the RNG on every match.
  pick_scan(get(rpi_nums), Target, 0, 0, -1).

pick_scan([], _Target, _I, _Count, Res) -> Res;
pick_scan([X | Xs], Target, I, Count, Res) when X =:= Target ->
  Count1 = Count + 1,
  Res1 = case rand:uniform(Count1) of 1 -> I; _ -> Res end,
  pick_scan(Xs, Target, I + 1, Count1, Res1);
pick_scan([_X | Xs], Target, I, Count, Res) ->
  pick_scan(Xs, Target, I + 1, Count, Res).


%% Your functions will be called as such:
%% solution_init_(Nums),
%% Param_1 = solution_pick(Target),

%% solution_init_ will be called before every test case, in which you can do some necessary initializations.
