-module(solution).
-export([custom_stack_init_/1, custom_stack_push/1, custom_stack_pop/0, custom_stack_increment/2]).
-include("node.hrl").

%% State in the process dictionary: {stack map, inc map, size, max size}.
%% Both maps are keyed by 0-based index; index 0 is the bottom of the stack.

-spec custom_stack_init_(MaxSize :: integer()) -> any().
custom_stack_init_(MaxSize) ->
    put(max, MaxSize),
    put(size, 0),
    put(stack, #{}),
    put(inc, #{}),
    ok.

-spec custom_stack_push(X :: integer()) -> any().
custom_stack_push(X) ->
    Size = get(size),
    case Size < get(max) of
        true ->
            put(stack, (get(stack))#{Size => X}),
            put(inc, (get(inc))#{Size => 0}),
            put(size, Size + 1);
        false ->
            ok
    end,
    ok.

-spec custom_stack_pop() -> integer().
custom_stack_pop() ->
    Size = get(size),
    case Size of
        0 -> -1;
        _ ->
            I = Size - 1,
            Stack = get(stack),
            Inc = get(inc),
            V = maps:get(I, Stack) + maps:get(I, Inc),
            Inc1 =
                case I > 0 of
                    true -> Inc#{(I - 1) => maps:get(I - 1, Inc) + maps:get(I, Inc)};
                    false -> Inc
                end,
            put(stack, maps:remove(I, Stack)),
            put(inc, maps:remove(I, Inc1)),
            put(size, I),
            V
    end.

-spec custom_stack_increment(K :: integer(), Val :: integer()) -> any().
custom_stack_increment(K, Val) ->
    I = min(K, get(size)) - 1,
    case I >= 0 of
        true ->
            Inc = get(inc),
            put(inc, Inc#{I => maps:get(I, Inc) + Val});
        false ->
            ok
    end,
    ok.
