% The Computer Language Benchmarks Game
% http://benchmarksgame.alioth.debian.org/
%
% regex-redux for Erlang.
%
% The raw contributed source was the obsolete regex-dna variant (IUB code
% expansion: B -> (c|g|t) ...), which does not match the current regex-redux
% task.  This implements the current regex-redux: count the nine variant
% patterns, then apply the five sequential substitutions, and report the
% original, cleaned and substituted lengths -- byte-for-byte compatible with
% the trusted C++ reference solution.

-module(regexredux).
-export([main/1]).

%% The nine variant patterns (counted, case-sensitive).
patterns() ->
    [<<"agggtaaa|tttaccct">>,
     <<"[cgt]gggtaaa|tttaccc[acg]">>,
     <<"a[act]ggtaaa|tttacc[agt]t">>,
     <<"ag[act]gtaaa|tttac[agt]ct">>,
     <<"agg[act]taaa|ttta[agt]cct">>,
     <<"aggg[acg]aaa|ttt[cgt]ccct">>,
     <<"agggt[cgt]aa|tt[acg]accct">>,
     <<"agggta[cgt]a|t[acg]taccct">>,
     <<"agggtaa[cgt]|[acg]ttaccct">>].

%% The five substitutions, applied in order.
subs() ->
    [{<<"tHa[Nt]">>,            <<"<4>">>},
     {<<"aND|caN|Ha[DS]|WaS">>, <<"<3>">>},
     {<<"a[NSt]|BY">>,          <<"<2>">>},
     {<<"<[^>]*>">>,            <<"|">>},
     {<<"\\|[^|][^|]*\\|">>,    <<"-">>}].

main(_) ->
    ok = io:setopts(standard_io, [binary]),
    Data = read_all([]),
    Len1 = byte_size(Data),
    %% Remove FASTA descriptions and newlines.
    Seq = re:replace(Data, <<">[^\n]+\n|\n">>, <<>>, [global, {return, binary}]),
    Len2 = byte_size(Seq),
    Self = self(),
    %% Substitutions run concurrently with the pattern counting.
    spawn(fun() -> Self ! {sub, do_subs(Seq)} end),
    Pats = patterns(),
    Indexed = lists:zip(lists:seq(1, length(Pats)), Pats),
    [ spawn(fun() -> Self ! {count, I, count_matches(Seq, P)} end)
      || {I, P} <- Indexed ],
    Counts = collect_counts(length(Pats), #{}),
    Len3 = receive {sub, S} -> S end,
    [ io:format("~s ~b~n", [P, maps:get(I, Counts)]) || {I, P} <- Indexed ],
    io:format("~n~b~n~b~n~b~n", [Len1, Len2, Len3]).

collect_counts(0, Acc) -> Acc;
collect_counts(N, Acc) ->
    receive {count, I, C} -> collect_counts(N - 1, Acc#{I => C}) end.

do_subs(Seq) ->
    Final = lists:foldl(
              fun({P, R}, Acc) ->
                      re:replace(Acc, P, R, [global, {return, binary}])
              end, Seq, subs()),
    byte_size(Final).

count_matches(Seq, Pat) ->
    case re:run(Seq, Pat, [global]) of
        {match, M} -> length(M);
        nomatch    -> 0
    end.

read_all(Acc) ->
    case file:read(standard_io, 65536) of
        {ok, Data} -> read_all([Data | Acc]);
        eof        -> iolist_to_binary(lists:reverse(Acc))
    end.
