%% Generic Erlang loop-harness + full-suite validator for the per-op
%% cross-language measurement. Reads the SAME shared JSON inputs as the other
%% languages, dispatches into the compiled `solution` module, and either checks
%% every reference case (validate/0) or loops ONE case to a wall-time budget
%% (run/2). The canon/fold form only needs to be INTERNALLY consistent.
%%
%% The shell (run_harness.sh / run_validate.sh) compiles solution.erl + this
%% module (erlc -I <selection_dir>) and runs:
%%   erl -noshell -pa <tmp> -eval 'perf_harness:validate()'        -s init stop
%%   erl -noshell -pa <tmp> -eval 'perf_harness:run("1.0","0")'    -s init stop
%%
%% CONVENTIONS: empty tree/list child = atom `null`; strings (input AND result)
%% are BINARIES (so they match JSON-decoded expected values); design/stateful
%% problems hold state in the process dictionary and reset it in *_init_.
-module(perf_harness).
-export([validate/0, run/2]).
-include("node.hrl").

-define(MASK64, ((1 bsl 64) - 1)).

%% ----------------------------------------------------------------- entry: validate
validate() ->
    {ok, Cwd} = file:get_cwd(),
    Slug = filename:basename(Cwd),
    try
        {Out, Camel} = load(Cwd, Slug),
        Expected = obj_get(Out, <<"expected">>),
        Total = length(Expected),
        Randomized = (Slug == "random-pick-index"),
        check(Expected, 0, Total, Slug, Camel, Randomized),
        io:format(standard_error, "VALIDATE slug=~s PASS ncases=~p passed=~p~n", [Slug, Total, Total]),
        halt(0)
    catch
        throw:{re, Name, I, Total2, E} ->
            io:format(standard_error, "VALIDATE slug=~s RE case=~s passed=~p ncases=~p ~p~n", [Slug, Name, I, Total2, E]),
            halt(3);
        Kind:Reason ->
            io:format(standard_error, "VALIDATE slug=~s ERROR load: ~p:~p~n", [Slug, Kind, Reason]),
            halt(2)
    end.

load(Cwd, Slug) ->
    Ref = filename:join([Cwd, "..", "..", "..", "reference", "leetcode"]),
    Out = parse_ordered(readf(filename:join([Ref, "outputs", Slug ++ ".json"]))),
    Wl = parse_ordered(readf(filename:join([Ref, "workloads", Slug ++ ".json"]))),
    Camel = lists:last(string:split(binary_to_list(obj_get(Wl, <<"entry_point">>)), ".", all)),
    {Out, Camel}.

check([], _I, _Total, _Slug, _Camel, _Rnd) -> ok;
check([C | Rest], I, Total, Slug, Camel, Rnd) ->
    Name = obj_get(C, <<"name">>),
    Inp = obj_get(C, <<"input">>),
    Exp = obj_get(C, <<"output">>),
    Actual =
        try run_case(Inp, Camel, Rnd)
        catch K:R -> throw({re, Name, I, Total, {K, R}}) end,
    Ok = case {design(Inp), lists:member(Slug, unordered())} of
             {true, _} -> seq_ok(Actual, Exp);
             {false, true} -> unordered_eq(Actual, Exp);
             {false, false} -> canon(Actual) == canon(Exp)
         end,
    case Ok of
        true -> check(Rest, I + 1, Total, Slug, Camel, Rnd);
        false ->
            io:format(standard_error,
                "VALIDATE slug=~s FAIL case=~s passed=~p ncases=~p expected=~s actual=~s~n",
                [Slug, Name, I, Total, slice(canon(Exp), 120), slice(canon(Actual), 120)]),
            halt(1)
    end.

unordered() -> ["uncommon-words-from-two-sentences", "remove-invalid-parentheses", "restore-the-array-from-adjacent-pairs"].

%% ----------------------------------------------------------------- entry: run (measure)
run(BudgetStr, IdxStr) ->
    {ok, Cwd} = file:get_cwd(),
    Slug = filename:basename(Cwd),
    Ref = filename:join([Cwd, "..", "..", "..", "reference", "leetcode"]),
    Budget = to_float(BudgetStr),
    Idx = list_to_integer(IdxStr),
    Out = parse_ordered(readf(filename:join([Ref, "outputs", Slug ++ ".json"]))),
    Case = lists:nth(Idx + 1, obj_get(Out, <<"expected">>)),
    Name = obj_get(Case, <<"name">>),
    Input = obj_get(Case, <<"input">>),
    Warm = Budget * 0.3,
    {One, Beacon} =
        case design(Input) of
            true -> {design_closure(Input), "design"};
            false ->
                Wl = parse_ordered(readf(filename:join([Ref, "workloads", Slug ++ ".json"]))),
                Camel = lists:last(string:split(binary_to_list(obj_get(Wl, <<"entry_point">>)), ".", all)),
                Args = build_args(Input),
                Meth = resolve(solution, Camel, length(Args)),
                B = apply(solution, Meth, Args),
                {fun() -> apply(solution, Meth, Args) end, binary_to_list(slice(canon(B), 80))}
        end,
    T0 = mono(),
    Wi = warm_loop(One, T0 + round(Warm * 1000000), 0),
    PerUs = case Wi > 0 of true -> (mono() - T0) / Wi; false -> Warm * 1000000 end,
    Batch = case PerUs > 0 of true -> min(max(trunc(2000 / PerUs), 1), 4096); false -> 4096 end,
    Tm = mono(),
    Deadline = Tm + round((Budget - Warm) * 1000000),
    {Acc, Iters} = measure_loop(One, Deadline, 0, 0, Batch),
    Meas = (mono() - Tm) / 1000000,
    io:format(standard_error, "CASE=~s ITERS=~p ACC=~p MEAS_S=~s BEACON=~s~n",
              [Name, Iters, Acc, fmt(Meas), Beacon]),
    halt(0).

design_closure(Input) ->
    [Op0 | RestOps] = obj_get(Input, <<"ops">>),
    [A0 | RestArgs] = obj_get(Input, <<"args">>),
    Pairs = lists:zip(RestOps, RestArgs),
    fun() ->
        apply(solution, design_func(Op0, init), A0),
        lists:foldl(fun({Op, A}, Acc) -> fold(Acc, apply(solution, design_func(Op0, Op), A)) end, 0, Pairs)
    end.

mono() -> erlang:monotonic_time(microsecond).

warm_loop(One, Deadline, N) ->
    case mono() >= Deadline of
        true -> N;
        false -> _ = One(), warm_loop(One, Deadline, N + 1)
    end.

measure_loop(One, Deadline, Acc, Iters, Batch) ->
    case mono() >= Deadline of
        true -> {Acc, Iters};
        false -> measure_loop(One, Deadline, do_batch(One, Acc, Batch), Iters + Batch, Batch)
    end.

do_batch(_One, Acc, 0) -> Acc;
do_batch(One, Acc, K) -> do_batch(One, fold(Acc, One()), K - 1).

%% ----------------------------------------------------------------- run one case (validate)
run_case(Input, Camel, Rnd) ->
    case design(Input) of
        true ->
            [Op0 | RestOps] = obj_get(Input, <<"ops">>),
            [A0 | RestArgs] = obj_get(Input, <<"args">>),
            Nums = case Rnd of true -> hd(A0); false -> undefined end,
            apply(solution, design_func(Op0, init), A0),
            Seq = [begin
                       R = apply(solution, design_func(Op0, Op), A),
                       case Rnd andalso Op == <<"pick">> andalso is_integer(R) of
                           true -> lists:nth(R + 1, Nums);
                           false -> R
                       end
                   end || {Op, A} <- lists:zip(RestOps, RestArgs)],
            [null | Seq];
        false ->
            Args = build_args(Input),
            apply(solution, resolve(solution, Camel, length(Args)), Args)
    end.

%% design function names: snake(class)++"_init_" for the ctor, snake(class)++"_"++snake(op) otherwise.
design_func(Class, init) -> list_to_atom(underscore(Class) ++ "_init_");
design_func(Class, Op) -> list_to_atom(underscore(Class) ++ "_" ++ underscore(Op)).

resolve(Mod, Camel, Arity) ->
    Snake = list_to_atom(underscore(Camel)),
    CamelA = to_atom(Camel),
    case erlang:function_exported(Mod, Snake, Arity) of
        true -> Snake;
        false ->
            case erlang:function_exported(Mod, CamelA, Arity) of
                true -> CamelA;
                false -> Snake
            end
    end.

%% ----------------------------------------------------------------- JSON (ordered)
%% Hand-rolled ordered JSON parser (no OTP :json dependency; works on any OTP).
%% Objects -> {object, [{Key, Value}, ...]} in source order; arrays -> lists;
%% JSON null -> the atom `null` (LeetCode's empty-node sentinel).
parse_ordered(Bin) ->
    {V, _Rest} = pval(skip_ws(Bin)),
    V.

skip_ws(<<C, R/binary>>) when C =:= $\s; C =:= $\t; C =:= $\n; C =:= $\r -> skip_ws(R);
skip_ws(B) -> B.

pval(<<${, R/binary>>) -> pobj(skip_ws(R), []);
pval(<<$[, R/binary>>) -> parr(skip_ws(R), []);
pval(<<$", R/binary>>) -> pstr(R, []);
pval(<<"true", R/binary>>) -> {true, R};
pval(<<"false", R/binary>>) -> {false, R};
pval(<<"null", R/binary>>) -> {null, R};
pval(B) -> pnum(B).

pobj(<<$}, R/binary>>, Acc) -> {{object, lists:reverse(Acc)}, R};
pobj(<<$", R/binary>>, Acc) ->
    {K, R1} = pstr(R, []),
    <<$:, R2/binary>> = skip_ws(R1),
    {V, R3} = pval(skip_ws(R2)),
    case skip_ws(R3) of
        <<$,, R4/binary>> -> pobj(skip_ws(R4), [{K, V} | Acc]);
        <<$}, R4/binary>> -> {{object, lists:reverse([{K, V} | Acc])}, R4}
    end.

parr(<<$], R/binary>>, Acc) -> {lists:reverse(Acc), R};
parr(B, Acc) ->
    {V, R1} = pval(B),
    case skip_ws(R1) of
        <<$,, R2/binary>> -> parr(skip_ws(R2), [V | Acc]);
        <<$], R2/binary>> -> {lists:reverse([V | Acc]), R2}
    end.

pstr(<<$", R/binary>>, Acc) -> {iolist_to_binary(lists:reverse(Acc)), R};
pstr(<<$\\, $u, H:4/binary, R/binary>>, Acc) ->
    pstr(R, [unicode:characters_to_binary([binary_to_integer(H, 16)]) | Acc]);
pstr(<<$\\, C, R/binary>>, Acc) -> pstr(R, [unesc(C) | Acc]);
pstr(<<C, R/binary>>, Acc) -> pstr(R, [C | Acc]).

unesc($n) -> $\n;
unesc($t) -> $\t;
unesc($r) -> $\r;
unesc($b) -> $\b;
unesc($f) -> $\f;
unesc(C) -> C.

pnum(B) ->
    {Tok, R} = take_num(B, []),
    L = binary_to_list(iolist_to_binary(lists:reverse(Tok))),
    {num_val(L), R}.

take_num(<<C, R/binary>>, Acc) when C =:= $-; C =:= $+; C >= $0, C =< $9; C =:= $.; C =:= $e; C =:= $E ->
    take_num(R, [C | Acc]);
take_num(B, Acc) -> {Acc, B}.

num_val(L) ->
    case lists:member($., L) of
        true -> list_to_float(L);
        false -> try list_to_integer(L) catch _:_ -> list_to_float(L) end
    end.

obj_get({object, Pairs}, Key) ->
    case lists:keyfind(Key, 1, Pairs) of
        {_, V} -> V;
        false -> undefined
    end.

design({object, Pairs}) ->
    lists:keymember(<<"ops">>, 1, Pairs) andalso lists:keymember(<<"args">>, 1, Pairs);
design(_) -> false.

build_args({object, Pairs}) ->
    [case K of
         <<"root">> -> build_tree(V);
         <<"head">> -> build_list(V);
         _ -> V
     end || {K, V} <- Pairs].

%% ----------------------------------------------------------------- nodes
build_tree(null) -> null;
build_tree([]) -> null;
build_tree([H | _]) when H == null -> null;
build_tree([RV | Rest]) ->
    {VM, CM} = bfs_assign([0], Rest, #{0 => RV}, #{}, 1),
    assemble(0, VM, CM).

bfs_assign(_Q, [], VM, CM, _N) -> {VM, CM};
bfs_assign([], _Rest, VM, CM, _N) -> {VM, CM};
bfs_assign([Pid | Q], Rest, VM, CM, N) ->
    {LV, Rest1} = take(Rest),
    {RV, Rest2} = take(Rest1),
    {VM1, CM1, Q1, N1} = put_child(VM, CM, Q, N, Pid, left, LV),
    {VM2, CM2, Q2, N2} = put_child(VM1, CM1, Q1, N1, Pid, right, RV),
    bfs_assign(Q2, Rest2, VM2, CM2, N2).

take([]) -> {none, []};
take([H | T]) -> {{val, H}, T}.

put_child(VM, CM, Q, N, _Pid, _Side, none) -> {VM, CM, Q, N};
put_child(VM, CM, Q, N, _Pid, _Side, {val, null}) -> {VM, CM, Q, N};
put_child(VM, CM, Q, N, Pid, Side, {val, V}) ->
    Kids = maps:get(Pid, CM, #{}),
    {VM#{N => V}, CM#{Pid => Kids#{Side => N}}, Q ++ [N], N + 1}.

assemble(Id, VM, CM) ->
    Kids = maps:get(Id, CM, #{}),
    #tree_node{
        val = maps:get(Id, VM),
        left = child_or_null(maps:get(left, Kids, none), VM, CM),
        right = child_or_null(maps:get(right, Kids, none), VM, CM)
    }.

child_or_null(none, _VM, _CM) -> null;
child_or_null(Id, VM, CM) -> assemble(Id, VM, CM).

build_list(null) -> null;
build_list([]) -> null;
build_list(L) when is_list(L) -> lists:foldr(fun(V, Acc) -> #list_node{val = V, next = Acc} end, null, L).

tree_to_list(null) -> [];
tree_to_list(Root) -> trim_null(bfs_tl([Root], [])).

bfs_tl([], Acc) -> lists:reverse(Acc);
bfs_tl([null | Q], Acc) -> bfs_tl(Q, [null | Acc]);
bfs_tl([#tree_node{val = V, left = L, right = R} | Q], Acc) -> bfs_tl(Q ++ [L, R], [V | Acc]).

trim_null(L) -> lists:reverse(lists:dropwhile(fun(X) -> X == null end, lists:reverse(L))).

list_to_list(null) -> [];
list_to_list(#list_node{val = V, next = N}) -> [V | list_to_list(N)].

%% ----------------------------------------------------------------- canon / fold
canon(null) -> <<"null">>;
canon(true) -> <<"true">>;
canon(false) -> <<"false">>;
canon(V) when is_integer(V) -> integer_to_binary(V);
canon(V) when is_float(V) ->
    T = trunc(V),
    case V == T of true -> integer_to_binary(T); false -> float_to_binary(V, [short]) end;
canon(V) when is_binary(V) -> json_string(V);
canon(#tree_node{} = T) -> canon(tree_to_list(T));
canon(#list_node{} = L) -> canon(list_to_list(L));
canon({object, Pairs}) -> canon_obj(Pairs);
canon(V) when is_map(V) -> canon_obj(maps:to_list(V));
canon(V) when is_list(V) ->
    iolist_to_binary([<<"[">>, lists:join(<<",">>, [canon(E) || E <- V]), <<"]">>]);
canon(V) when is_atom(V) -> json_string(atom_to_binary(V, utf8));
canon(V) -> json_string(iolist_to_binary(io_lib:format("~p", [V]))).

canon_obj(Pairs) ->
    Sorted = lists:sort(fun({A, _}, {B, _}) -> to_bin(A) =< to_bin(B) end, Pairs),
    Body = lists:join(<<",">>, [iolist_to_binary([json_string(to_bin(K)), <<":">>, canon(V)]) || {K, V} <- Sorted]),
    iolist_to_binary([<<"{">>, Body, <<"}">>]).

to_bin(B) when is_binary(B) -> B;
to_bin(A) when is_atom(A) -> atom_to_binary(A, utf8);
to_bin(L) when is_list(L) -> list_to_binary(L).

json_string(B0) ->
    B = to_bin(B0),
    E1 = binary:replace(B, <<"\\">>, <<"\\\\">>, [global]),
    E2 = binary:replace(E1, <<"\"">>, <<"\\\"">>, [global]),
    E3 = binary:replace(E2, <<"\n">>, <<"\\n">>, [global]),
    E4 = binary:replace(E3, <<"\t">>, <<"\\t">>, [global]),
    <<"\"", E4/binary, "\"">>.

strhash(B) -> lists:foldl(fun(Byte, H) -> (H * 31 + Byte) band 16#FFFFFFFF end, 0, binary_to_list(B)).

fold(Acc, R) -> (Acc * 1000003 + strhash(canon(R))) band ?MASK64.

%% ----------------------------------------------------------------- compare helpers
seq_ok(A, E) when is_list(A), is_list(E), length(A) == length(E) ->
    lists:all(fun({Av, Ev}) -> Ev == null orelse canon(Av) == canon(Ev) end, lists:zip(A, E));
seq_ok(_, _) -> false.

unordered_eq(A, E) when is_list(A), is_list(E) ->
    lists:sort([canon(X) || X <- A]) == lists:sort([canon(X) || X <- E]);
unordered_eq(A, E) -> canon(A) == canon(E).

%% ----------------------------------------------------------------- misc
underscore(S) when is_binary(S) -> underscore(binary_to_list(S));
underscore(S) when is_atom(S) -> underscore(atom_to_list(S));
underscore(S) ->
    S1 = re:replace(S, "([A-Z]+)([A-Z][a-z])", "\\1_\\2", [global, {return, list}]),
    S2 = re:replace(S1, "([a-z0-9])([A-Z])", "\\1_\\2", [global, {return, list}]),
    string:lowercase(S2).

to_atom(S) when is_binary(S) -> binary_to_atom(S, utf8);
to_atom(S) when is_list(S) -> list_to_atom(S).

slice(Bin, N) when byte_size(Bin) =< N -> Bin;
slice(Bin, N) -> binary:part(Bin, 0, N).

readf(Path) -> {ok, Bin} = file:read_file(Path), Bin.

to_float(S) ->
    try list_to_float(S)
    catch _:_ -> float(list_to_integer(S)) end.

fmt(X) -> lists:flatten(io_lib:format("~.6f", [X * 1.0])).
