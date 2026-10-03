-module(solution).
-export([stream_checker_init_/1, stream_checker_query/1]).
-include("node.hrl").

-spec stream_checker_init_(Words :: [unicode:unicode_binary()]) -> any().
stream_checker_init_(Words) ->
  {Trie, MaxLen} = lists:foldl(
      fun(W, {T, ML}) ->
          Bytes = binary_to_list(W),
          Rev = lists:reverse(Bytes),
          {insert(Rev, T), max(ML, length(Bytes))}
      end, {#{}, 0}, Words),
  put(sc_trie, Trie),
  put(sc_maxlen, MaxLen),
  put(sc_stream, []),
  ok.

-spec stream_checker_query(Letter :: char()) -> boolean().
stream_checker_query(Letter) ->
  C = letter_byte(Letter),
  Max = get(sc_maxlen),
  Stream = lists:sublist([C | get(sc_stream)], Max),
  put(sc_stream, Stream),
  walk(Stream, get(sc_trie)).


%% Your functions will be called as such:
%% stream_checker_init_(Words),
%% Param_1 = stream_checker_query(Letter),

%% stream_checker_init_ will be called before every test case, in which you can do some necessary initializations.

insert([], T) -> T#{'$' => true};
insert([C | Rest], T) ->
  Child = maps:get(C, T, #{}),
  T#{C => insert(Rest, Child)}.

%% Stream is most-recent-first; walk consumes it one node at a time.
walk([], _Node) -> false;
walk([C | Rest], Node) ->
  case maps:find(C, Node) of
      error -> false;
      {ok, Child} ->
          case maps:get('$', Child, false) of
              true -> true;
              false -> walk(Rest, Child)
          end
  end.

letter_byte(B) when is_binary(B) -> binary:first(B);
letter_byte(C) when is_integer(C) -> C;
letter_byte([C | _]) -> C.
