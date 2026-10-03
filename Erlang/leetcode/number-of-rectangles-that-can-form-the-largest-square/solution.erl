-module(solution).
-export([count_good_rectangles/1]).
-include("node.hrl").

count_good_rectangles(Rectangles) ->
    {_MaxLen, Count} =
        lists:foldl(fun([W, H], {MaxLen, Cnt}) ->
                        Side = min(W, H),
                        if
                            Side > MaxLen -> {Side, 1};
                            Side =:= MaxLen -> {MaxLen, Cnt + 1};
                            true -> {MaxLen, Cnt}
                        end
                    end, {0, 0}, Rectangles),
    Count.
