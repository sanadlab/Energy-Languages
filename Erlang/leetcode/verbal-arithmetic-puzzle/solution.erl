-module(solution).
-export([is_solvable/2]).
-include("node.hrl").

-spec is_solvable(Words :: [unicode:unicode_binary()], Result :: unicode:unicode_binary()) -> boolean().
is_solvable(Words, Result) ->
  WordsB = [binary_to_list(W) || W <- Words],
  ResultB = binary_to_list(Result),
  MaxLen = length(ResultB),
  case lists:any(fun(W) -> length(W) > MaxLen end, WordsB) of
      true -> false;
      false ->
          Leading0 = set_of([hd(W) || W <- WordsB, length(W) > 1]),
          Leading = case MaxLen > 1 of
                        true -> Leading0#{hd(ResultB) => true};
                        false -> Leading0
                    end,
          WordsT = list_to_tuple([list_to_tuple(W) || W <- WordsB]),
          Lens = list_to_tuple([length(W) || W <- WordsB]),
          NumWords = length(WordsB),
          ResultT = list_to_tuple(ResultB),
          St = {WordsT, Lens, NumWords, ResultT, MaxLen, Leading},
          solve(St, 0, 0, 0, #{}, #{})
  end.

set_of(List) -> lists:foldl(fun(X, M) -> M#{X => true} end, #{}, List).

solve(St, Col, Row, Carry, Assigned, Used) ->
  {WordsT, Lens, NumWords, ResultT, MaxLen, Leading} = St,
  if
      Col == MaxLen ->
          Carry == 0;
      Row < NumWords ->
          WLen = element(Row + 1, Lens),
          if
              Col >= WLen ->
                  solve(St, Col, Row + 1, Carry, Assigned, Used);
              true ->
                  W = element(Row + 1, WordsT),
                  Ch = element(WLen - Col, W),
                  case maps:is_key(Ch, Assigned) of
                      true -> solve(St, Col, Row + 1, Carry, Assigned, Used);
                      false -> try_digits(St, Col, Row, Carry, Assigned, Used, Ch, 0)
                  end
          end;
      true ->
          S = Carry + sum_col(WordsT, Lens, NumWords, Assigned, Col, 0, 0),
          Digit = S rem 10,
          NewCarry = S div 10,
          Rch = element(MaxLen - Col, ResultT),
          case maps:find(Rch, Assigned) of
              {ok, DV} ->
                  case DV == Digit of
                      true -> solve(St, Col + 1, 0, NewCarry, Assigned, Used);
                      false -> false
                  end;
              error ->
                  case maps:is_key(Digit, Used) of
                      true -> false;
                      false ->
                          case Digit == 0 andalso maps:is_key(Rch, Leading) of
                              true -> false;
                              false ->
                                  solve(St, Col + 1, 0, NewCarry,
                                        Assigned#{Rch => Digit}, Used#{Digit => true})
                          end
                  end
          end
  end.

try_digits(_St, _Col, _Row, _Carry, _Assigned, _Used, _Ch, 10) -> false;
try_digits(St, Col, Row, Carry, Assigned, Used, Ch, D) ->
  {_, _, _, _, _, Leading} = St,
  CanUse = (not maps:is_key(D, Used))
      andalso not (D == 0 andalso maps:is_key(Ch, Leading)),
  case CanUse of
      true ->
          case solve(St, Col, Row + 1, Carry, Assigned#{Ch => D}, Used#{D => true}) of
              true -> true;
              false -> try_digits(St, Col, Row, Carry, Assigned, Used, Ch, D + 1)
          end;
      false ->
          try_digits(St, Col, Row, Carry, Assigned, Used, Ch, D + 1)
  end.

sum_col(_WordsT, _Lens, NumWords, _Assigned, _Col, Idx, Acc) when Idx >= NumWords -> Acc;
sum_col(WordsT, Lens, NumWords, Assigned, Col, Idx, Acc) ->
  WLen = element(Idx + 1, Lens),
  Acc2 = case Col < WLen of
             true ->
                 W = element(Idx + 1, WordsT),
                 Ch = element(WLen - Col, W),
                 Acc + maps:get(Ch, Assigned);
             false -> Acc
         end,
  sum_col(WordsT, Lens, NumWords, Assigned, Col, Idx + 1, Acc2).
