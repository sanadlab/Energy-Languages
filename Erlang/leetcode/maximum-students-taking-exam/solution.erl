-module(solution).
-export([max_students/1]).
-include("node.hrl").

-spec max_students(Seats :: [[char()]]) -> integer().
max_students([]) -> 0;
max_students(Seats) ->
  N = length(hd(Seats)),
  Full = 1 bsl N,
  Avail = [row_mask(Row, N) || Row <- Seats],
  BestFinal = lists:foldl(fun(Ai, Best) -> process_row(Ai, Full, Best) end, #{0 => 0}, Avail),
  lists:max(maps:values(BestFinal)).

process_row(AvailI, Full, Best) ->
  PrevList = maps:to_list(Best),
  lists:foldl(
    fun(Mask, Ndp) ->
      case valid_mask(Mask, AvailI) of
        false -> Ndp;
        true ->
          case best_prev(Mask, PrevList, -1) of
            -1 -> Ndp;
            BestVal -> maps:put(Mask, BestVal + popcount(Mask), Ndp)
          end
      end
    end, #{}, lists:seq(0, Full - 1)).

valid_mask(Mask, AvailI) ->
  (Mask band AvailI) =:= Mask andalso (Mask band (Mask bsl 1)) =:= 0.

best_prev(_Mask, [], Acc) -> Acc;
best_prev(Mask, [{Pmask, Val} | Rest], Acc) ->
  case (Mask band (Pmask bsl 1)) =:= 0 andalso (Mask band (Pmask bsr 1)) =:= 0 of
    true -> best_prev(Mask, Rest, max(Acc, Val));
    false -> best_prev(Mask, Rest, Acc)
  end.

row_mask(Row, N) -> row_mask(Row, 0, N, 0).
row_mask([], _J, _N, Acc) -> Acc;
row_mask(_Row, J, N, Acc) when J >= N -> Acc;
row_mask([Cell | Rest], J, N, Acc) ->
  Acc1 = case Cell =:= <<".">> of true -> Acc bor (1 bsl J); false -> Acc end,
  row_mask(Rest, J + 1, N, Acc1).

popcount(0) -> 0;
popcount(X) -> (X band 1) + popcount(X bsr 1).
