-module(solution).
-export([min_days/1]).
-include("node.hrl").

-spec min_days(N :: integer()) -> integer().
min_days(N) ->
  {R, _Memo} = solve(N, #{}),
  R.

solve(X, Memo) when X =< 1 -> {X, Memo};
solve(X, Memo) ->
  case maps:find(X, Memo) of
    {ok, V} -> {V, Memo};
    error ->
      {A, Memo1} = solve(X div 2, Memo),
      {B, Memo2} = solve(X div 3, Memo1),
      Res = 1 + min(X rem 2 + A, X rem 3 + B),
      {Res, maps:put(X, Res, Memo2)}
  end.
