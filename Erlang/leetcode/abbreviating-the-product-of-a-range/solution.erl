-module(solution).
-export([abbreviate_product/2]).
-include("node.hrl").

-spec abbreviate_product(Left :: integer(), Right :: integer()) -> unicode:unicode_binary().
abbreviate_product(Left, Right) ->
  P = product(Left, Right, 1),
  {P2, C} = strip_zeros(P, 0),
  S = integer_to_binary(P2),
  Len = byte_size(S),
  Cb = integer_to_binary(C),
  case Len =< 10 of
    true ->
      <<S/binary, "e", Cb/binary>>;
    false ->
      First5 = binary:part(S, 0, 5),
      Last5 = binary:part(S, Len - 5, 5),
      <<First5/binary, "...", Last5/binary, "e", Cb/binary>>
  end.

product(I, Right, Acc) when I =< Right -> product(I + 1, Right, Acc * I);
product(_I, _Right, Acc) -> Acc.

strip_zeros(P, C) when P > 0, P rem 10 =:= 0 -> strip_zeros(P div 10, C + 1);
strip_zeros(P, C) -> {P, C}.
