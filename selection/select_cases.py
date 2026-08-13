#!/usr/bin/env python3
"""STEP 2: fingerprint -> cluster -> medoid case selection (SimPoint-style).

Reads the step-1 dataset (fp.jsonl) and, per problem:
  1. builds a behavior fingerprint per case from the perf counters,
  2. standardizes -> PCA (90% var),
  3. picks cluster count k by silhouette, k-means, and takes the medoid of
     each cluster as the representative case,
  4. compares the fingerprint selection against a plain size-spread pick, and
     reports whether PC1 is basically "size" — i.e. whether the fancy method
     even beats sorting by input size on THIS data.

  usage: select_cases.py [fp.jsonl] [--tau 1.0] [--out selection.json]
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
    """One fingerprint vector per case: log-magnitudes + shape ratios."""
    X, meta = [], []
    for r in rows:
        g = lambda k: float(r.get(k, 0.0) or 0.0)
        instr = g("instructions_per_op") or 1.0
        cyc   = g("cycles_per_op") or 1.0
        cref  = g("cache-references_per_op") or 1.0
        br    = g("branches_per_op") or 1.0
        feat = [np.log1p(g(k)) for k in MAG] + [
            g("cache-misses_per_op")/cref,      # cache-miss rate
            g("branch-misses_per_op")/br,       # branch-mispredict rate
            instr/cyc,                          # IPC
        ]
        X.append(feat); meta.append(r)
    return np.array(X, float), meta

def pick_k(Xp, nmax):
    best_k, best_s = 2, -1
    for k in range(2, min(nmax, 8)+1):
        try:
            lab = KMeans(n_clusters=k, n_init=5, random_state=0).fit_predict(Xp)
            if len(set(lab)) < 2: continue
            s = silhouette_score(Xp, lab)
            if s > best_s: best_s, best_k = s, k
        except Exception: pass
    return best_k, best_s

def size_spread(meta, k):
    order = sorted(range(len(meta)), key=lambda i: meta[i]["size"])
    if len(order) <= k: return set(m["case"] for m in meta)
    idxs = sorted(set(round(j*(len(order)-1)/(k-1)) for j in range(k)))
    return set(meta[order[j]]["case"] for j in idxs)

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("fp", nargs="?", default="fp.jsonl")
    ap.add_argument("--out", default="selection.json")
    ap.add_argument("--min-cases", type=int, default=6)
    args = ap.parse_args()

    by = collections.defaultdict(list)
    for line in open(args.fp):
        r = json.loads(line)
        if r.get("status") == "ok" and r.get("instructions_per_op"):
            by[r["problem"]].append(r)

    selection = {}
    agree_scores, pc1_size_corr, ks = [], [], []
    for prob, rows in sorted(by.items()):
        if len(rows) < args.min_cases:
            selection[prob] = {"selected":[r["case"] for r in rows],"note":"few cases; take all"}
            continue
        X, meta = featurize(rows)
        # drop zero-variance columns, standardize, PCA to ~90% var
        X = X[:, X.std(0) > 1e-9] if (X.std(0) > 1e-9).any() else X
        Xs = StandardScaler().fit_transform(X)
        p = PCA(n_components=min(Xs.shape[1], Xs.shape[0]-1)).fit(Xs)
        ncomp = max(1, int(np.searchsorted(np.cumsum(p.explained_variance_ratio_), 0.90)+1))
        Xp = p.transform(Xs)[:, :ncomp]
        k, sil = pick_k(Xp, len(rows)-1)
        km = KMeans(n_clusters=k, n_init=5, random_state=0).fit(Xp)
        # medoid per cluster = case nearest its centroid
        medoids = []
        for c in range(k):
            idx = np.where(km.labels_ == c)[0]
            if len(idx) == 0: continue
            d = np.linalg.norm(Xp[idx] - km.cluster_centers_[c], axis=1)
            medoids.append(meta[idx[d.argmin()]])
        sel = [m["case"] for m in medoids]
        # does fingerprint selection differ from a size-spread pick of same size?
        szpick = size_spread(meta, len(sel))
        overlap = len(set(sel) & szpick)/max(1,len(sel))         # 1.0 == identical to size pick
        sizes = np.array([m["size"] for m in meta], float)
        pc1 = Xp[:,0]
        corr = abs(np.corrcoef(pc1, np.log1p(sizes))[0,1]) if sizes.std()>0 else 0.0
        agree_scores.append(overlap); pc1_size_corr.append(corr); ks.append(k)
        selection[prob] = {"n_cases":len(rows),"k":k,"silhouette":round(float(sil),3),
                           "selected":sel,"selected_idx":[m["idx"] for m in medoids],
                           "overlap_with_size_pick":round(overlap,2),
                           "pc1_vs_logsize_corr":round(float(corr),2)}

    json.dump(selection, open(args.out,"w"), indent=1)
    print(f"problems selected: {len(selection)}")
    print(f"cluster count k: mean={np.mean(ks):.1f} range={min(ks)}-{max(ks)}")
    print(f"\n== does fingerprinting beat size-sorting on this data? ==")
    print(f"  mean overlap of fingerprint-medoids with size-spread pick: {np.mean(agree_scores):.2f}")
    print(f"    (1.00 = fingerprinting picks the SAME cases as sorting by size => no added value)")
    print(f"  mean |corr(PC1, log size)|: {np.mean(pc1_size_corr):.2f}")
    print(f"    (near 1.0 => the main behavior axis IS just input size)")
    diff = sum(1 for a in agree_scores if a < 0.75)
    print(f"  problems where fingerprint selection meaningfully differs (overlap<0.75): {diff}/{len(agree_scores)}")
    print(f"\nwrote {args.out}")

main()
