-module(solution).
-export([k_length_apart/2]).
-include("node.hrl").

-spec k_length_apart(Nums :: [integer()], K :: integer()) -> boolean().
k_length_apart(Nums, K) ->
  check(Nums, 0, -1, K).

check([], _I, _Prev, _K) -> true;
check([1 | T], I, Prev, K) ->
  case Prev =/= -1 andalso (I - Prev - 1) < K of
    true -> false;
    false -> check(T, I + 1, I, K)
  end;
check([_ | T], I, Prev, K) ->
  check(T, I + 1, Prev, K).
