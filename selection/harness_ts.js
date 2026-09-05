// Generic TypeScript loop-harness for the cross-language transfer check.
// TypeScript is dynamic like JS: at run time we transpile solution.ts -> JS
// (type-stripping via the TS compiler API, no type-checking) and then reuse the
// exact JavaScript harness approach. Plain-data args pass straight through; only
// tree/list/design need construction.
//
//   node harness_ts.js <budget_seconds> <case_index>   (run from the TS cell dir)
//   prints CASE/ITERS/ACC/BEACON to STDERR (stdout stays empty).
const fs = require('fs');
const path = require('path');
const cp = require('child_process');

// ---- locate the TypeScript compiler (transpileModule = pure syntactic strip) ----
function loadTS() {
  try { return require('typescript'); } catch (e) {}
  try {
    const gr = cp.execSync('npm root -g', { encoding: 'utf8' }).trim();
    return require(path.join(gr, 'typescript'));
  } catch (e) {}
  try { return require('/usr/local/lib/node_modules/typescript'); } catch (e) {}
  throw new Error('TypeScript compiler (transpileModule) not found');
}
const ts = loadTS();
function transpile(src) {
  return ts.transpileModule(src, {
    compilerOptions: {
      // ES2019, NOT ES2020: `??` and `?.` are ES2020 syntax, so an ES2020
      // target leaves them untouched and `new Function(jsSrc)` then throws
      // "Unexpected token '?'" on any Node older than 14. Targeting ES2019
      // makes TypeScript down-level them (to `!== null && !== void 0 ? …`),
      // so the transpiled solution runs regardless of the runner's Node
      // version. Only solutions using that syntax hit this; the rest passed.
      target: ts.ScriptTarget.ES2019,
      module: ts.ModuleKind.CommonJS,
      removeComments: false,
    },
  }).outputText;
}

// ---- tree / list plumbing (identical to harness.js) ----
function TreeNode(v){ this.val=v; this.left=null; this.right=null; }
function ListNode(v){ this.val=v; this.next=null; }
// expose so a solution that constructs nodes at run time still resolves them
globalThis.TreeNode = TreeNode;
globalThis.ListNode = ListNode;
function buildTree(a){
  if(!a || !a.length || a[0]==null) return null;
  const root=new TreeNode(a[0]); const q=[root]; let i=1;
  while(i<a.length && q.length){ const n=q.shift();
    if(i<a.length){ const lv=a[i++]; if(lv!=null){ n.left=new TreeNode(lv); q.push(n.left); } }
    if(i<a.length){ const rv=a[i++]; if(rv!=null){ n.right=new TreeNode(rv); q.push(n.right); } } }
  return root;
}
function buildList(a){ if(!a || !a.length) return null; const h=new ListNode(a[0]); let c=h;
  for(let i=1;i<a.length;i++){ c.next=new ListNode(a[i]); c=c.next; } return h; }
function clone(o){
  if(Array.isArray(o)) return o.map(clone);
  if(o instanceof TreeNode) return buildTree(treeToArr(o));
  if(o instanceof ListNode) return buildList(listToArr(o));
  return o;                                   // primitives / strings
}
function treeToArr(r){ const a=[]; const q=[r]; while(q.length){ const n=q.shift();
    if(n==null){ a.push(null); } else { a.push(n.val); q.push(n.left); q.push(n.right); } }
  while(a.length && a[a.length-1]==null) a.pop(); return a; }
function listToArr(h){ const a=[]; while(h){ a.push(h.val); h=h.next; } return a; }
function canon(r){
  if(r===undefined || r===null) return "null";          // void design methods return undefined
  if(r instanceof ListNode) return JSON.stringify(listToArr(r));
  if(r instanceof TreeNode) return JSON.stringify(treeToArr(r));
  try { const s = JSON.stringify(r); return s === undefined ? "null" : s; } catch(e){ return String(r); }
}
function fold(acc, r){ let h=0; const s=canon(r); for(let i=0;i<s.length;i++) h=(h*31 + s.charCodeAt(i))|0; return (acc*1000003 + h)|0; }

const cell = process.cwd();
const slug = path.basename(cell);
const ref  = path.join(cell, '..', '..', '..', 'reference', 'leetcode');
const out  = JSON.parse(fs.readFileSync(path.join(ref,'outputs',slug+'.json'),'utf8'));
const budget = parseFloat(process.argv[2]);
const idx    = parseInt(process.argv[3]);
const kase = out.expected[idx];
const input = kase.input;

// transpile solution.ts -> JS once. All the solution's top-level declarations
// (function / class / const / let / var) live in ONE Function body scope; a
// trailing `return <name>` inside that same body can therefore read any of them
// regardless of strict mode (this is why we don't rely on sloppy-eval leakage).
const jsSrc = transpile(fs.readFileSync(path.join(cell,'solution.ts'),'utf8'));
function grab(name){
  return (new Function(jsSrc + '\n;return (typeof ' + name + " === 'undefined') ? undefined : " + name + ';'))();
}

function now(){ return process.hrtime.bigint(); }
function secs(a,b){ return Number(b-a)/1e9; }
let acc=0, iters=0, beacon;

if(input && typeof input==='object' && 'ops' in input && 'args' in input){
  // design-class replay: ops[0] = class name, args[0] = ctor args, then method calls
  const ops=input.ops, args=input.args;
  const Cls = grab(ops[0]);
  const replay = () => { const inst = new Cls(...clone(args[0])); let a=0;
    for(let i=1;i<ops.length;i++) a=fold(a, inst[ops[i]](...clone(args[i]))); return a; };
  // stateful replay -> args cloned each pass (kept); batch the clock read.
  let wi=0, tw=now(); while(secs(tw,now()) < budget*0.3){ replay(); wi++; }
  const perIter = wi ? secs(tw,now())/wi : budget*0.3;
  const batch = perIter>0 ? Math.max(1, Math.min(4096, Math.floor(0.002/perIter))) : 4096;
  let tm=now();
  while(secs(tm,now()) < budget*0.7){ for(let b=0;b<batch;b++){ acc=fold(acc, replay()); } iters+=batch; }
  const meas=secs(tm,now());
  process.stderr.write(`CASE=${kase.name} ITERS=${iters} ACC=${acc} MEAS_S=${meas.toFixed(6)} BEACON=design\n`);
} else {
  const wl = JSON.parse(fs.readFileSync(path.join(ref,'workloads',slug+'.json'),'utf8'));
  const method = String(wl.entry_point||'').split('.').pop();
  // build args (tree/list by conventional key name; else pass through)
  const base = Object.keys(input).map(k =>
      k==='root' ? buildTree(input[k]) : k==='head' ? buildList(input[k]) : input[k]);
  const SolCls = grab('Solution');            // defined only if solution has `class Solution`
  const fn = SolCls ? null : grab(method);    // otherwise the top-level function
  const call = (a) => SolCls ? new SolCls()[method](...a) : fn(...a);
  // (1) detect mutation once; skip the per-iteration clone when the solution
  //     leaves its input untouched. `base` is a throwaway probe copy; `pristine`
  //     is the clean reference reused when non-mutating.
  const pristine = base.map(clone);
  const snap = pristine.map(canon).join('\x1e');
  beacon = call(base);
  const mutated = base.map(canon).join('\x1e') !== snap;
  const one = mutated ? (() => call(pristine.map(clone))) : (() => call(pristine));
  // (3) estimate per-iter cost during warmup, then batch the wall-clock read
  let wi=0, tw=now(); while(secs(tw,now()) < budget*0.3){ one(); wi++; }
  const perIter = wi ? secs(tw,now())/wi : budget*0.3;
  const batch = perIter>0 ? Math.max(1, Math.min(4096, Math.floor(0.002/perIter))) : 4096;
  let tm=now();
  while(secs(tm,now()) < budget*0.7){ for(let b=0;b<batch;b++){ acc=fold(acc, one()); } iters+=batch; }
  const meas=secs(tm,now());
  process.stderr.write(`CASE=${kase.name} ITERS=${iters} ACC=${acc} MEAS_S=${meas.toFixed(6)} BEACON=${canon(beacon).slice(0,80)}\n`);
}
