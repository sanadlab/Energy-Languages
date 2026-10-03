-module(solution).
-export([min_days/3]).
-include("node.hrl").

-spec min_days(BloomDay :: [integer()], M :: integer(), K :: integer()) -> integer().
min_days(BloomDay, M, K) ->
  case M * K > length(BloomDay) of
    true -> -1;
    false ->
      Lo = lists:min(BloomDay),
      Hi = lists:max(BloomDay),
      bsearch(Lo, Hi, BloomDay, M, K)
  end.

bsearch(Lo, Hi, _BD, _M, _K) when Lo >= Hi ->
  Lo;
bsearch(Lo, Hi, BD, M, K) ->
  Mid = (Lo + Hi) div 2,
  case can_make(BD, Mid, K) >= M of
    true -> bsearch(Lo, Mid, BD, M, K);
    false -> bsearch(Mid + 1, Hi, BD, M, K)
  end.

can_make(BD, Day, K) ->
  {Bouquets, _Flowers} =
    lists:foldl(
      fun(B, {Bq, Fl}) ->
        case B =< Day of
          true ->
            case Fl + 1 of
              K -> {Bq + 1, 0};
              NF -> {Bq, NF}
            end;
          false -> {Bq, 0}
        end
      end, {0, 0}, BD),
  Bouquets.
