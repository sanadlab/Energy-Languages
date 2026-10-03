%% Shared node records for Erlang LeetCode cells + the perf harness/validator.
%% LeetCode's Erlang convention: an empty child/list is the atom `null`.
%% solution.erl and the harness both `-include("node.hrl").` (compiled with
%% `erlc -I <selection_dir>`), so the record layout is identical on both sides.
-record(tree_node, {val = 0 :: integer(),
                    left = null  :: 'null' | #tree_node{},
                    right = null :: 'null' | #tree_node{}}).

-record(list_node, {val = 0 :: integer(),
                    next = null :: 'null' | #list_node{}}).
