#!/usr/bin/env python3
"""Curate the final reduced test-case set (consistent fancy method, all problems).

Per problem:
  - fingerprint each case (perf-counter behavior), standardize -> PCA(90%),
  - k-means (k by silhouette), take the MEDOID of each cluster as a kept case,
  - ALWAYS keep the worst-case (max energy-per-op) input,
  - MAXIMIN SPACE-FILL up to --min-kept cases: greedily add the case farthest (in
    the multi-dimensional PCA fingerprint space) from any kept case -> covers
    behavioral diversity, not just the 1-D energy axis (farthest-first / greedy
    k-center; a recognized space-filling design). Since energy ~ instructions
    (r~1.0), this subsumes energy coverage and adds the cache/branch axes,
  - WEIGHT each kept case by its 1-NN (Voronoi) share in fingerprint space: each
    full case votes for its nearest kept case; weights sum to 1.0 so a weighted
    mean over the kept cases reproduces the full-suite mean.

Emits `curated_selection.json`.  usage: curate.py fp_all.jsonl [--out ...]
                                                    [--min-kept 5] [--max-kept 8]
"""
import sys, json, argparse, collections
import numpy as np
from sklearn.preprocessing import StandardScaler
from sklearn.decomposition import PCA
from sklearn.cluster import KMeans
from sklearn.metrics import silhouette_score

MAG = ["instructions_per_op","cycles_per_op","cache-references_per_op",
       "cache-misses_per_op","branches_per_op","branch-misses_per_op"]

def featurize(rows):
    X = []
    for r in rows:
        g = lambda k: float(r.get(k, 0.0) or 0.0)
        cref = g("cache-references_per_op") or 1.0
        br   = g("branches_per_op") or 1.0
        cyc  = g("cycles_per_op") or 1.0
        X.append([np.log1p(g(k)) for k in MAG] +
                 [g("cache-misses_per_op")/cref, g("branch-misses_per_op")/br,
                  g("instructions_per_op")/cyc])
    return np.array(X, float)

def pick_k(Xp, nmax):
    best_k, best_s = 2, -1
    for k in range(2, min(nmax, 8)+1):
        try:
            lab = KMeans(n_clusters=k, n_init=5, random_state=0).fit_predict(Xp)
            if len(set(lab)) < 2: continue
            s = silhouette_score(Xp, lab)
            if s > best_s: best_s, best_k = s, k
        except Exception: pass
    return best_k

def meta(r):
    return {"case": r["case"], "idx": r["idx"], "size": r["size"],
            "energy_uj_per_op": round(float(r["energy_uj_per_op"]), 2),
            "instructions_per_op": round(float(r.get("instructions_per_op", 0)), 0)}

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("fp")
    ap.add_argument("--out", default="curated_selection.json")
    ap.add_argument("--min-kept", type=int, default=5)
    ap.add_argument("--max-kept", type=int, default=8)
    ap.add_argument("--energy-weight", type=float, default=1.0,
                    help="weight of the log-energy axis in the space-fill/weight space")
    args = ap.parse_args()

    by = collections.defaultdict(list)
    for line in open(args.fp):
        r = json.loads(line)
        if r.get("status") == "ok" and r.get("instructions_per_op") and float(r.get("energy_uj_per_op",0))>0:
            by[r["problem"]].append(r)

    curated = {}
    for prob, rows in sorted(by.items()):
        N = len(rows)
        X = featurize(rows)
        X = X[:, X.std(0) > 1e-9] if (X.std(0) > 1e-9).any() else X
        Xs = StandardScaler().fit_transform(X)
        pca = PCA(n_components=min(Xs.shape[1], Xs.shape[0]-1)).fit(Xs)
        ncomp = max(1, int(np.searchsorted(np.cumsum(pca.explained_variance_ratio_), 0.90)+1))
        Xp = pca.transform(Xs)[:, :ncomp]
        logE = np.log10(np.array([r["energy_uj_per_op"] for r in rows], float))
        sizes = np.array([r["size"] for r in rows], float)
        corr = float(abs(np.corrcoef(Xp[:,0], np.log1p(sizes))[0,1])) if sizes.std() > 0 else 0.0

        # COMBINED space for fill + weighting: fingerprint PCA axes PLUS the
        # response variable (log-energy) as an explicit, weighted axis, so
        # space-filling covers behavioral diversity AND the cost range together.
        ze = (logE - logE.mean()) / (logE.std() or 1.0)
        Xfill = np.hstack([Xp, (args.energy_weight * ze)[:, None]])

        k = pick_k(Xp, N-1)
        km = KMeans(n_clusters=k, n_init=5, random_state=0).fit(Xp)
        kept_pos, roles = [], {}          # position in rows -> role
        for c in range(k):
            idx = np.where(km.labels_ == c)[0]
            if len(idx) == 0: continue
            d = np.linalg.norm(Xp[idx] - km.cluster_centers_[c], axis=1)
            p = int(idx[d.argmin()]); kept_pos.append(p); roles[p] = "medoid"
        # worst case always kept
        wp = int(np.argmax(logE))
        if wp in roles: roles[wp] = "medoid+worst"
        else: kept_pos.append(wp); roles[wp] = "worst-case"
        # MAXIMIN space-filling fill up to min_kept (cap at max_kept):
        # greedily add the case FARTHEST (in the PCA fingerprint space) from every
        # already-kept case -> covers behavioral diversity, not just the 1-D energy
        # axis (farthest-first / greedy k-center; a recognized space-filling design).
        target = min(args.min_kept, N)
        kset = set(kept_pos)
        while len(kept_pos) < target and len(kept_pos) < args.max_kept:
            best_p, best_d = -1, -1.0
            for j in range(N):
                if j in kset: continue
                d = min(float(np.linalg.norm(Xfill[j] - Xfill[q])) for q in kept_pos)
                if d > best_d: best_d, best_p = d, j
            kept_pos.append(best_p); kset.add(best_p); roles[best_p] = "maximin-fill"

        # Voronoi weights in fingerprint space: each full case -> nearest kept
        kp = np.array(kept_pos)
        nearest = np.array([int(kp[np.linalg.norm(Xfill[kp]-Xfill[j], axis=1).argmin()]) for j in range(N)])
        counts = collections.Counter(nearest.tolist())
        kept = [{**meta(rows[p]), "role": roles[p], "cluster": int(km.labels_[p]),
                 "weight": round(counts.get(p, 0)/N, 4)} for p in kept_pos]
        curated[prob] = {"n_total": N, "k": k,
                         "regime": "size-dominated" if corr > 0.7 else "behavior-mode",
                         "pc1_size_corr": round(corr, 2), "kept": kept}

    json.dump(curated, open(args.out, "w"), indent=1)

    total_kept = sum(len(v["kept"]) for v in curated.values())
    total_full = sum(v["n_total"] for v in curated.values())
    per = [len(v["kept"]) for v in curated.values()]
    print(f"problems curated: {len(curated)}")
    print(f"kept total: {total_kept} (of {total_full}) = {100*total_kept/total_full:.1f}%  ({total_full/total_kept:.0f}x reduction)")
    print(f"kept per problem: min={min(per)} median={int(np.median(per))} max={max(per)} mean={sum(per)/len(per):.1f}")
    print(f"kept histogram: {dict(sorted(collections.Counter(per).items()))}")
    print(f"roles: {dict(collections.Counter(kc['role'] for v in curated.values() for kc in v['kept']))}")
    wsum_ok = all(abs(sum(kc['weight'] for kc in v['kept'])-1.0) < 0.03 for v in curated.values())
    print(f"weights sum to 1.0 per problem: {wsum_ok}")
    print(f"wrote {args.out}")

main()
