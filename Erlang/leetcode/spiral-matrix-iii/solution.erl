-module(solution).
-export([spiral_matrix_iii/4]).
-include("node.hrl").

-spec spiral_matrix_iii(Rows :: integer(), Cols :: integer(), RStart :: integer(), CStart :: integer()) -> [[integer()]].
spiral_matrix_iii(Rows, Cols, RStart, CStart) ->
  Total = Rows * Cols,
  {Acc0, Cnt0} = case in_bounds(RStart, CStart, Rows, Cols) of
                   true -> {[[RStart, CStart]], 1};
                   false -> {[], 0}
                 end,
  Dr = {0, 1, 0, -1},
  Dc = {1, 0, -1, 0},
  AccRev = loop(RStart, CStart, Acc0, Cnt0, 1, 0, Total, Rows, Cols, Dr, Dc),
  lists:reverse(AccRev).

loop(_R, _C, Acc, Cnt, _Step, _D, Total, _Rows, _Cols, _Dr, _Dc) when Cnt >= Total -> Acc;
loop(R, C, Acc, Cnt, Step, D, Total, Rows, Cols, Dr, Dc) ->
  {R1, C1, Acc1, Cnt1} = pass(R, C, Acc, Cnt, Step, D, Rows, Cols, Dr, Dc),
  {R2, C2, Acc2, Cnt2} = pass(R1, C1, Acc1, Cnt1, Step, D + 1, Rows, Cols, Dr, Dc),
  loop(R2, C2, Acc2, Cnt2, Step + 1, D + 2, Total, Rows, Cols, Dr, Dc).

pass(R, C, Acc, Cnt, 0, _D, _Rows, _Cols, _Dr, _Dc) -> {R, C, Acc, Cnt};
pass(R, C, Acc, Cnt, K, D, Rows, Cols, Dr, Dc) ->
  Dir = (D rem 4) + 1,
  R1 = R + element(Dir, Dr),
  C1 = C + element(Dir, Dc),
  {Acc1, Cnt1} = case in_bounds(R1, C1, Rows, Cols) of
                   true -> {[[R1, C1] | Acc], Cnt + 1};
                   false -> {Acc, Cnt}
                 end,
  pass(R1, C1, Acc1, Cnt1, K - 1, D, Rows, Cols, Dr, Dc).

in_bounds(R, C, Rows, Cols) ->
  R >= 0 andalso R < Rows andalso C >= 0 andalso C < Cols.
