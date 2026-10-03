-module(solution).
-export([next_beautiful_number/1]).
-include("node.hrl").

-spec next_beautiful_number(N :: integer()) -> integer().
next_beautiful_number(N) ->
  search(N + 1).

search(X) ->
  case balanced(X) of
    true -> X;
    false -> search(X + 1)
  end.

balanced(X) ->
  check_digits(0, count_digits(X, #{})).

count_digits(0, Acc) -> Acc;
count_digits(T, Acc) ->
  count_digits(T div 10, maps:update_with(T rem 10, fun(C) -> C + 1 end, 1, Acc)).

check_digits(10, _Cnt) -> true;
check_digits(D, Cnt) ->
  C = maps:get(D, Cnt, 0),
  case C =/= 0 andalso C =/= D of
    true -> false;
    false -> check_digits(D + 1, Cnt)
  end.
