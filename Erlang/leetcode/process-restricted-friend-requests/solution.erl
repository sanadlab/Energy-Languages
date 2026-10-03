-module(solution).
-export([friend_requests/3]).
-include("node.hrl").

-spec friend_requests(N :: integer(), Restrictions :: [[integer()]], Requests :: [[integer()]]) -> [boolean()].
friend_requests(N, Restrictions, Requests) ->
  P0 = maps:from_list([{I, I} || I <- lists:seq(0, N - 1)]),
  {_P, Res} = lists:foldl(
    fun([U, V], {P, Acc}) ->
      {PU, P1} = find(U, P),
      {PV, P2} = find(V, P1),
      case PU =:= PV of
        true -> {P2, [true | Acc]};
        false ->
          {Ok, P3} = check_restrictions(Restrictions, PU, PV, P2),
          case Ok of
            true -> {P3#{PU => PV}, [true | Acc]};
            false -> {P3, [false | Acc]}
          end
      end
    end, {P0, []}, Requests),
  lists:reverse(Res).

check_restrictions([], _PU, _PV, P) -> {true, P};
check_restrictions([[X, Y] | T], PU, PV, P) ->
  {PX, P1} = find(X, P),
  {PY, P2} = find(Y, P1),
  case (PX =:= PU andalso PY =:= PV) orelse (PX =:= PV andalso PY =:= PU) of
    true -> {false, P2};
    false -> check_restrictions(T, PU, PV, P2)
  end.

find(X, P) ->
  case maps:get(X, P) of
    X -> {X, P};
    PX ->
      PPX = maps:get(PX, P),
      find(PPX, P#{X => PPX})
  end.
