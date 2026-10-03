-module(solution).
-export([min_sessions/2]).
-include("node.hrl").

-spec min_sessions(Tasks :: [integer()], SessionTime :: integer()) -> integer().
min_sessions(Tasks, SessionTime) ->
  N = length(Tasks),
  TT = list_to_tuple(Tasks),
  Full = (1 bsl N) - 1,
  %% DP: mask => {sessions, used}; an absent mask means sessions = INF.
  DP0 = #{0 => {1, 0}},
  DP = loop_mask(0, Full, N, TT, SessionTime, DP0),
  {Ses, _Used} = maps:get(Full, DP),
  Ses.

loop_mask(Mask, Full, _N, _TT, _ST, DP) when Mask > Full -> DP;
loop_mask(Mask, Full, N, TT, ST, DP) ->
  DP1 = case maps:get(Mask, DP, infinity) of
          infinity -> DP;
          {Ses, Used} -> loop_i(0, N, Mask, Ses, Used, TT, ST, DP)
        end,
  loop_mask(Mask + 1, Full, N, TT, ST, DP1).

loop_i(I, N, _Mask, _Ses, _Used, _TT, _ST, DP) when I >= N -> DP;
loop_i(I, N, Mask, Ses, Used, TT, ST, DP) ->
  Bit = 1 bsl I,
  DP1 =
    case Mask band Bit of
      0 ->
        Nm = Mask bor Bit,
        Ti = element(I + 1, TT),
        {Ns, Nu} =
          case Used + Ti =< ST of
            true -> {Ses, Used + Ti};
            false -> {Ses + 1, Ti}
          end,
        case better(Ns, Nu, maps:get(Nm, DP, infinity)) of
          true -> DP#{Nm => {Ns, Nu}};
          false -> DP
        end;
      _ -> DP
    end,
  loop_i(I + 1, N, Mask, Ses, Used, TT, ST, DP1).

better(_Ns, _Nu, infinity) -> true;
better(Ns, Nu, {OldSes, OldUsed}) ->
  Ns < OldSes orelse (Ns =:= OldSes andalso Nu < OldUsed).
