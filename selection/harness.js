// Generic JavaScript loop-harness for the cross-language transfer check.
// Reads the SAME shared JSON inputs, calls the solution, loops to a wall-time
// budget (checksum-consumed, iteration-counted). JS is dynamic, so plain-data
// args pass straight through; only tree/list/design need construction.
//
//   node harness.js <budget_seconds> <case_index>   (run from the JS cell dir)
//   prints CASE/ITERS/ACC/BEACON to STDERR (stdout stays empty).
const fs = require('fs');
const path = require('path');

function TreeNode(v){ this.val=v; this.left=null; this.right=null; }
function ListNode(v){ this.val=v; this.next=null; }
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
// V8's native JSON.stringify + a simple int charloop is faster than a pure-JS
// recursive structural checksum (per-node type dispatch dominates), so the fold
// stays string-based here — the win in JS comes from skipping the input clone.
function fold(acc, r){ let h=0; const s=canon(r); for(let i=0;i<s.length;i++) h=(h*31 + s.charCodeAt(i))|0; return (acc*1000003 + h)|0; }

const cell = process.cwd();
const slug = path.basename(cell);
const ref  = path.join(cell, '..', '..', '..', 'reference', 'leetcode');
const out  = JSON.parse(fs.readFileSync(path.join(ref,'outputs',slug+'.json'),'utf8'));
const budget = parseFloat(process.argv[2]);
const idx    = parseInt(process.argv[3]);
const kase = out.expected[idx];
const input = kase.input;

// bring the solution's top-level defs into this scope
eval(fs.readFileSync(path.join(cell,'solution.js'),'utf8'));

function now(){ return process.hrtime.bigint(); }
function secs(a,b){ return Number(b-a)/1e9; }
let acc=0, iters=0, beacon;

if('ops' in input && 'args' in input){
  // design-class replay: ops[0] = class name, args[0] = ctor args, then method calls
  const ops=input.ops, args=input.args;
  const Cls = eval(ops[0]);
  const replay = () => { const inst = new Cls(...clone(args[0])); let a=0;
    for(let i=1;i<ops.length;i++) a=fold(a, inst[ops[i]](...clone(args[i]))); return a; };
  // stateful replay -> args cloned each pass (kept); batch the clock read.
  let wi=0, tw=now(); while(secs(tw,now()) < budget*0.3){ replay(); wi++; }
  const perIter = wi ? secs(tw,now())/wi : budget*0.3;
  const batch = perIter>0 ? Math.max(1, Math.min(4096, Math.floor(0.002/perIter))) : 4096;
  let tm=now();
  while(secs(tm,now()) < budget*0.7){ for(let b=0;b<batch;b++){ acc=(acc*1000003 + replay())|0; } iters+=batch; }
  const meas=secs(tm,now());
  process.stderr.write(`CASE=${kase.name} ITERS=${iters} ACC=${acc} MEAS_S=${meas.toFixed(6)} BEACON=design\n`);
} else {
  const wl = JSON.parse(fs.readFileSync(path.join(ref,'workloads',slug+'.json'),'utf8'));
  const method = String(wl.entry_point||'').split('.').pop();
  // build args (tree/list by conventional key name; else pass through)
  const base = Object.keys(input).map(k =>
      k==='root' ? buildTree(input[k]) : k==='head' ? buildList(input[k]) : input[k]);
  const hasSol = (typeof Solution !== 'undefined');
  const call = (a) => hasSol ? new Solution()[method](...a) : eval(method)(...a);
  // (1) detect mutation once; skip the per-iteration clone when the solution
  //     leaves its input untouched (the common case). `base` is a throwaway
  //     probe copy; `pristine` is the clean reference reused when non-mutating.
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
