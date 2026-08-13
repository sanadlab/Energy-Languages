#!/usr/bin/env python3
"""Fair check: does the FINGERPRINT clustering differ from a SIZE clustering?

Earlier metric (medoid vs size-extreme) was apples-to-oranges. Here we cluster
each problem two ways with the SAME k — once on the full behavior fingerprint,
once on input size alone — and compare the groupings with Adjusted Rand Index.
  ARI ~ 1.0  => fingerprinting just reproduces size grouping (no added value)
  ARI < ~0.5 => fingerprinting finds groups size cannot see (real added value)
"""
import sys, json, collections
import numpy as np
from sklearn.preprocessing import StandardScaler
from sklearn.decomposition import PCA
from sklearn.cluster import KMeans
from sklearn.metrics import adjusted_rand_score, silhouette_score

MAG=["instructions_per_op","cycles_per_op","cache-references_per_op",
     "cache-misses_per_op","branches_per_op","branch-misses_per_op"]
def feats(rows):
    X=[]
    for r in rows:
        g=lambda k: float(r.get(k,0.0) or 0.0)
        cref=g("cache-references_per_op") or 1.0; br=g("branches_per_op") or 1.0; cyc=g("cycles_per_op") or 1.0
        X.append([np.log1p(g(k)) for k in MAG]+[g("cache-misses_per_op")/cref, g("branch-misses_per_op")/br, g("instructions_per_op")/cyc])
    return np.array(X,float)
def pick_k(Xp,nmax):
    bk,bs=2,-1
    for k in range(2,min(nmax,8)+1):
        try:
            lab=KMeans(n_clusters=k,n_init=5,random_state=0).fit_predict(Xp)
            if len(set(lab))<2: continue
            s=silhouette_score(Xp,lab)
            if s>bs: bs,bk=s,k
        except Exception: pass
    return bk

by=collections.defaultdict(list)
for l in open(sys.argv[1]):
    r=json.loads(l)
    if r.get("status")=="ok" and r.get("instructions_per_op"): by[r["problem"]].append(r)

aris=[]
for prob,rows in sorted(by.items()):
    if len(rows)<6: continue
    X=feats(rows); X=X[:,X.std(0)>1e-9] if (X.std(0)>1e-9).any() else X
    Xs=StandardScaler().fit_transform(X)
    pca=PCA(n_components=min(Xs.shape[1],Xs.shape[0]-1)).fit(Xs)
    nc=max(1,int(np.searchsorted(np.cumsum(pca.explained_variance_ratio_),0.90)+1))
    Xp=pca.transform(Xs)[:,:nc]
    k=pick_k(Xp,len(rows)-1)
    fp_lab=KMeans(n_clusters=k,n_init=5,random_state=0).fit_predict(Xp)
    sz=np.log1p(np.array([[r["size"]] for r in rows],float))
    if sz.std()<1e-9:
        aris.append((prob,k,1.0)); continue
    sz_lab=KMeans(n_clusters=k,n_init=5,random_state=0).fit_predict(StandardScaler().fit_transform(sz))
    aris.append((prob,k,adjusted_rand_score(fp_lab,sz_lab)))

vals=[a for _,_,a in aris]
print(f"problems compared: {len(vals)}")
print(f"ARI(fingerprint-clustering vs size-clustering): mean={np.mean(vals):.2f} median={np.median(vals):.2f}")
print(f"  ARI>0.8 (fingerprint ~= size): {sum(v>0.8 for v in vals)}/{len(vals)}")
print(f"  ARI<0.5 (fingerprint adds real structure): {sum(v<0.5 for v in vals)}/{len(vals)}")
print("\nproblems where fingerprinting most differs from size (lowest ARI):")
for prob,k,a in sorted(aris,key=lambda x:x[2])[:10]:
    print(f"  ARI={a:+.2f} k={k}  {prob}")
