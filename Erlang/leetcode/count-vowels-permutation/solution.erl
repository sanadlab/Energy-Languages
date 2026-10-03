-module(solution).
-export([count_vowel_permutation/1]).
-include("node.hrl").

-define(MOD, 1000000007).

-spec count_vowel_permutation(N :: integer()) -> integer().
count_vowel_permutation(N) ->
  %% dp state ends with vowel a,e,i,o,u. Base case: length-1 strings => 1 each.
  {A, E, I, O, U} = step(2, N, {1, 1, 1, 1, 1}),
  (A + E + I + O + U) rem ?MOD.

step(I, N, Dp) when I > N -> Dp;
step(I, N, {A, E, Iv, O, U}) ->
  A1 = E rem ?MOD,
  E1 = (A + Iv) rem ?MOD,
  I1 = (A + E + O + U) rem ?MOD,
  O1 = (Iv + U) rem ?MOD,
  U1 = A rem ?MOD,
  step(I + 1, N, {A1, E1, I1, O1, U1}).
