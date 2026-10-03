-module(solution).
-export([ambiguous_coordinates/1]).
-include("node.hrl").

-spec ambiguous_coordinates(S :: unicode:unicode_binary()) -> [unicode:unicode_binary()].
ambiguous_coordinates(S) ->
  L = binary_to_list(S),
  Digits = lists:sublist(L, 2, length(L) - 2),
  N = length(Digits),
  [ iolist_to_binary(io_lib:format("(~s, ~s)", [A, B]))
    || I <- lists:seq(1, N - 1),
       A <- make(lists:sublist(Digits, 1, I)),
       B <- make(lists:sublist(Digits, I + 1, N - I)) ].

make(D) ->
  N = length(D),
  case N of
    1 -> [D];
    _ ->
      Head = case hd(D) of $0 -> []; _ -> [D] end,
      Decs = [ Lp ++ "." ++ Rp
               || I <- lists:seq(1, N - 1),
                  Lp <- [lists:sublist(D, 1, I)],
                  Rp <- [lists:sublist(D, I + 1, N - I)],
                  (Lp == "0" orelse hd(Lp) =/= $0),
                  lists:last(Rp) =/= $0 ],
      Head ++ Decs
  end.
