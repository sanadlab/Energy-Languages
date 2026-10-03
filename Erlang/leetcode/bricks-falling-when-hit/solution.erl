-module(solution).
-export([hit_bricks/2]).
-include("node.hrl").

-spec hit_bricks(Grid :: [[integer()]], Hits :: [[integer()]]) -> [integer()].
hit_bricks(Grid, Hits) ->
  M = length(Grid),
  N = case Grid of
        [Row0 | _] when is_list(Row0) -> length(Row0);
        _ -> 0
      end,
  Total = M * N,
  Top = Total,
  %% Set of indices (r*n+c) that originally hold a brick (value 1).
  Orig = build_orig(Grid, N),
  %% Working brick set = original bricks with the hit cells erased up front.
  HitPairs = [{R, C} || [R, C | _] <- Hits],
  G0 = erase_hits(HitPairs, M, N, Orig),
  %% Union-find over the bricks that remain. parent default x, size default 1.
  {P0, Sz0} = build_uf(0, M, N, G0, Top, #{}, #{}),
  %% Restore hits in reverse order, measuring the growth of the top component.
  HitsVec = list_to_tuple(Hits),
  Len = length(Hits),
  Res = process_hits(Len - 1, HitsVec, M, N, G0, Orig, Top, P0, Sz0, #{}),
  [maps:get(I, Res, 0) || I <- lists:seq(0, Len - 1)].

%% ---------------------------------------------------------------- original bricks
build_orig(Grid, N) ->
  {_, Orig} =
    lists:foldl(
      fun(Row, {R, Acc}) -> {R + 1, add_row(Row, R, 0, N, Acc)} end,
      {0, #{}}, Grid),
  Orig.

add_row([], _R, _C, _N, Acc) -> Acc;
add_row([_ | _], _R, C, N, Acc) when C >= N -> Acc;
add_row([V | T], R, C, N, Acc) ->
  Acc1 = case V =:= 1 of true -> Acc#{R * N + C => true}; false -> Acc end,
  add_row(T, R, C + 1, N, Acc1).

erase_hits([], _M, _N, G) -> G;
erase_hits([{R, C} | T], M, N, G) ->
  G1 = case in_bounds(R, C, M, N) of
         true -> maps:remove(R * N + C, G);
         false -> G
       end,
  erase_hits(T, M, N, G1).

%% ---------------------------------------------------------------- build union-find
build_uf(R, M, _N, _G, _Top, P, Sz) when R >= M -> {P, Sz};
build_uf(R, M, N, G, Top, P, Sz) ->
  {P1, Sz1} = build_uf_row(R, 0, M, N, G, Top, P, Sz),
  build_uf(R + 1, M, N, G, Top, P1, Sz1).

build_uf_row(_R, C, _M, N, _G, _Top, P, Sz) when C >= N -> {P, Sz};
build_uf_row(R, C, M, N, G, Top, P, Sz) ->
  Idx = R * N + C,
  {P1, Sz1} =
    case maps:is_key(Idx, G) of
      false -> {P, Sz};
      true ->
        {Pa, Sza} = case R =:= 0 of
                      true -> union(Idx, Top, P, Sz);
                      false -> {P, Sz}
                    end,
        {Pb, Szb} = case R > 0 andalso maps:is_key((R - 1) * N + C, G) of
                      true -> union(Idx, (R - 1) * N + C, Pa, Sza);
                      false -> {Pa, Sza}
                    end,
        case C > 0 andalso maps:is_key(R * N + C - 1, G) of
          true -> union(Idx, R * N + C - 1, Pb, Szb);
          false -> {Pb, Szb}
        end
    end,
  build_uf_row(R, C + 1, M, N, G, Top, P1, Sz1).

%% ---------------------------------------------------------------- restore hits
process_hits(I, _Hits, _M, _N, _G, _Orig, _Top, _P, _Sz, Res) when I < 0 -> Res;
process_hits(I, Hits, M, N, G, Orig, Top, P, Sz, Res) ->
  [R, C | _] = element(I + 1, Hits),
  {G1, P1, Sz1, Res1} =
    case in_bounds(R, C, M, N) of
      false -> {G, P, Sz, Res};
      true ->
        Idx = R * N + C,
        case maps:is_key(Idx, Orig) of
          false -> {G, P, Sz, Res};
          true ->
            {Root0, Pb} = find(Top, P),
            Before = maps:get(Root0, Sz, 1),
            G2 = G#{Idx => true},
            {P2, Sz2} = case R =:= 0 of
                          true -> union(Idx, Top, Pb, Sz);
                          false -> {Pb, Sz}
                        end,
            {P3, Sz3} = union_neighbors(R, C, M, N, Idx, G2, P2, Sz2),
            {Root1, P4} = find(Top, P3),
            After = maps:get(Root1, Sz3, 1),
            Val = max(0, After - Before - 1),
            {G2, P4, Sz3, Res#{I => Val}}
        end
    end,
  process_hits(I - 1, Hits, M, N, G1, Orig, Top, P1, Sz1, Res1).

union_neighbors(R, C, M, N, Idx, G, P, Sz) ->
  Dirs = [{1, 0}, {-1, 0}, {0, 1}, {0, -1}],
  lists:foldl(
    fun({DR, DC}, {Pa, Sza}) ->
      NR = R + DR, NC = C + DC,
      case in_bounds(NR, NC, M, N) andalso maps:is_key(NR * N + NC, G) of
        true -> union(Idx, NR * N + NC, Pa, Sza);
        false -> {Pa, Sza}
      end
    end, {P, Sz}, Dirs).

%% ---------------------------------------------------------------- union-find core
find(X, P) ->
  case maps:get(X, P, X) of
    X -> {X, P};
    Px ->
      Gp = maps:get(Px, P, Px),  %% path halving: parent[x] = parent[parent[x]]
      find(Gp, P#{X => Gp})
  end.

union(A, B, P, Sz) ->
  {Ra, P1} = find(A, P),
  {Rb, P2} = find(B, P1),
  case Ra =:= Rb of
    true -> {P2, Sz};
    false ->
      Sa = maps:get(Ra, Sz, 1),
      Sb = maps:get(Rb, Sz, 1),
      {Big, Small} = case Sa < Sb of true -> {Rb, Ra}; false -> {Ra, Rb} end,
      {P2#{Small => Big}, Sz#{Big => maps:get(Big, Sz, 1) + maps:get(Small, Sz, 1)}}
  end.

in_bounds(R, C, M, N) -> R >= 0 andalso R < M andalso C >= 0 andalso C < N.
