-module(solution).
-export([remove_invalid_parentheses/1]).
-include("node.hrl").

-spec remove_invalid_parentheses(S :: unicode:unicode_binary()) -> [unicode:unicode_binary()].
remove_invalid_parentheses(S) ->
  bfs(#{S => true}).

bfs(Level) when map_size(Level) == 0 -> [<<"">>];
bfs(Level) ->
  Keys = maps:keys(Level),
  Valids = [St || St <- Keys, valid(St)],
  case Valids of
    [_ | _] -> Valids;
    [] ->
      Next = lists:foldl(fun(St, Acc) -> expand(St, Acc) end, #{}, Keys),
      bfs(Next)
  end.

expand(St, Acc) ->
  N = byte_size(St),
  expand(St, N, 0, Acc).

expand(_St, N, I, Acc) when I >= N -> Acc;
expand(St, N, I, Acc) ->
  C = binary:at(St, I),
  Acc1 = case C =:= $( orelse C =:= $) of
           true ->
             Pre = binary:part(St, 0, I),
             Post = binary:part(St, I + 1, N - I - 1),
             Acc#{<<Pre/binary, Post/binary>> => true};
           false -> Acc
         end,
  expand(St, N, I + 1, Acc1).

valid(St) -> valid(St, 0, 0, byte_size(St)).

valid(_St, I, Cnt, N) when I >= N -> Cnt == 0;
valid(St, I, Cnt, N) ->
  case binary:at(St, I) of
    $( -> valid(St, I + 1, Cnt + 1, N);
    $) when Cnt =< 0 -> false;
    $) -> valid(St, I + 1, Cnt - 1, N);
    _ -> valid(St, I + 1, Cnt, N)
  end.
