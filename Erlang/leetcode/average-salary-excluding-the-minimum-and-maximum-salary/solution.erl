-module(solution).
-export([average/1]).
-include("node.hrl").

-spec average(Salary :: [integer()]) -> float().
average([H | _] = Salary) ->
    {Mn, Mx, Total} =
        lists:foldl(fun(S, {Mn, Mx, Tot}) ->
                        {min(Mn, S), max(Mx, S), Tot + S}
                    end, {H, H, 0}, Salary),
    (Total - Mn - Mx) / (length(Salary) - 2).
