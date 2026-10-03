-module(solution).
-export([max_equal_freq/1]).
-include("node.hrl").

-spec max_equal_freq(Nums :: [integer()]) -> integer().
max_equal_freq(Nums) ->
  {_Count, _Freq, _MaxF, Res, _I} =
    lists:foldl(fun step/2, {#{}, #{}, 0, 0, 0}, Nums),
  Res.

step(V, {Count, Freq, MaxF, Res, I}) ->
  Cv = maps:get(V, Count, 0),
  Freq1 = case Cv > 0 of
            true -> dec(Freq, Cv);
            false -> Freq
          end,
  Nc = Cv + 1,
  Count1 = Count#{V => Nc},
  Freq2 = inc(Freq1, Nc),
  MaxF1 = max(MaxF, Nc),
  FMax = maps:get(MaxF1, Freq2, 0),
  Cond =
    MaxF1 =:= 1
    orelse FMax * MaxF1 =:= I
    orelse (FMax =:= 1 andalso (MaxF1 - 1) * (maps:get(MaxF1 - 1, Freq2, 0) + 1) =:= I),
  Res1 = case Cond of true -> I + 1; false -> Res end,
  {Count1, Freq2, MaxF1, Res1, I + 1}.

inc(M, K) -> maps:update_with(K, fun(X) -> X + 1 end, 1, M).
dec(M, K) -> maps:update_with(K, fun(X) -> X - 1 end, -1, M).
