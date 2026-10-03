-module(solution).
-export([maximum_and_sum/2]).
-include("node.hrl").

-spec maximum_and_sum(Nums :: [integer()], NumSlots :: integer()) -> integer().
maximum_and_sum(Nums, NumSlots) ->
  N = length(Nums),
  Full = (1 bsl N) - 1,
  Size = 1 bsl N,
  NumsT = list_to_tuple(Nums),
  Dp0 = erlang:make_tuple(Size, -1),
  Dp1 = setelement(1, Dp0, 0),
  DpFinal = slots_loop(1, NumSlots, N, NumsT, Dp1, Size),
  V = element(Full + 1, DpFinal),
  case V >= 0 of true -> V; false -> 0 end.

slots_loop(Slot, NumSlots, _N, _NumsT, Dp, _Size) when Slot > NumSlots ->
  Dp;
slots_loop(Slot, NumSlots, N, NumsT, Dp, Size) ->
  mask_loop(0, Size, N, NumsT, Dp, Slot),
  Ndp = build_ndp(0, Size, Dp, []),
  slots_loop(Slot + 1, NumSlots, N, NumsT, Ndp, Size).

%% Process every mask against the OLD dp (the tuple Dp), writing the new values
%% into the process dictionary (lazy copy: an unset key defaults to Dp's value).
mask_loop(Mask, Size, _N, _NumsT, _Dp, _Slot) when Mask >= Size ->
  ok;
mask_loop(Mask, Size, N, NumsT, Dp, Slot) ->
  Base = element(Mask + 1, Dp),
  case Base < 0 of
    true -> ok;
    false -> i_loop(0, N, Mask, Base, NumsT, Dp, Slot)
  end,
  mask_loop(Mask + 1, Size, N, NumsT, Dp, Slot).

i_loop(I, N, _Mask, _Base, _NumsT, _Dp, _Slot) when I >= N ->
  ok;
i_loop(I, N, Mask, Base, NumsT, Dp, Slot) ->
  case (Mask bsr I) band 1 of
    1 -> ok;
    0 ->
      Nm = Mask bor (1 bsl I),
      V = Base + (element(I + 1, NumsT) band Slot),
      bump(Nm, V, Dp),
      j_loop(I + 1, N, Mask, V, NumsT, Dp, Slot, Nm)
  end,
  i_loop(I + 1, N, Mask, Base, NumsT, Dp, Slot).

j_loop(J, N, _Mask, _V, _NumsT, _Dp, _Slot, _Nm) when J >= N ->
  ok;
j_loop(J, N, Mask, V, NumsT, Dp, Slot, Nm) ->
  case (Mask bsr J) band 1 of
    1 -> ok;
    0 ->
      Nm2 = Nm bor (1 bsl J),
      V2 = V + (element(J + 1, NumsT) band Slot),
      bump(Nm2, V2, Dp)
  end,
  j_loop(J + 1, N, Mask, V, NumsT, Dp, Slot, Nm).

bump(Idx, V, Dp) ->
  Cur = case get(Idx) of
          undefined -> element(Idx + 1, Dp);
          X -> X
        end,
  case V > Cur of
    true -> put(Idx, V);
    false -> ok
  end.

build_ndp(Mask, Size, _Dp, Acc) when Mask >= Size ->
  list_to_tuple(lists:reverse(Acc));
build_ndp(Mask, Size, Dp, Acc) ->
  V = case erase(Mask) of
        undefined -> element(Mask + 1, Dp);
        X -> X
      end,
  build_ndp(Mask + 1, Size, Dp, [V | Acc]).
