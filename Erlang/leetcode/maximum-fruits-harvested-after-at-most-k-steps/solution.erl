-module(solution).
-export([max_total_fruits/3]).
-include("node.hrl").

-spec max_total_fruits(Fruits :: [[integer()]], StartPos :: integer(), K :: integer()) -> integer().
max_total_fruits(Fruits, StartPos, K) ->
  N = length(Fruits),
  T = list_to_tuple([{P, A} || [P, A] <- Fruits]),
  scan(0, N, T, StartPos, K, 0, 0, 0).

scan(J, N, _T, _SP, _K, _I, _Total, Best) when J >= N -> Best;
scan(J, N, T, SP, K, I, Total, Best) ->
  {_, AmtJ} = element(J + 1, T),
  Total1 = Total + AmtJ,
  {I1, Total2} = shrink(I, J, T, SP, K, Total1),
  Best1 = case I1 =< J andalso Total2 > Best of
            true -> Total2;
            false -> Best
          end,
  scan(J + 1, N, T, SP, K, I1, Total2, Best1).

shrink(I, J, T, SP, K, Total) when I =< J ->
  {PosI, AmtI} = element(I + 1, T),
  {PosJ, _} = element(J + 1, T),
  case cost(PosI, PosJ, SP) > K of
    true -> shrink(I + 1, J, T, SP, K, Total - AmtI);
    false -> {I, Total}
  end;
shrink(I, _J, _T, _SP, _K, Total) -> {I, Total}.

cost(PosL, PosR, SP) when PosR =< SP -> SP - PosL;
cost(PosL, PosR, SP) when PosL >= SP -> PosR - SP;
cost(PosL, PosR, SP) -> (PosR - PosL) + min(SP - PosL, PosR - SP).
