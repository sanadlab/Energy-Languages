// Full-suite correctness validator (JavaScript). Runs solution.js against
// EVERY reference case and compares each result to the expected output. Run
// FROM the cell dir:  node ../../../selection/validate_suite.js
// Reuses harness.js's tree/list/canon logic so correctness judges the exact
// same shared inputs the measurement harness does.
// Prints one VALIDATE line to stderr. Exit: 0 Accepted, 1 Wrong Answer,
// 3 Runtime Error, 2 setup error.
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
function treeToArr(r){ const a=[]; const q=[r]; while(q.length){ const n=q.shift();
    if(n==null){ a.push(null); } else { a.push(n.val); q.push(n.left); q.push(n.right); } }
  while(a.length && a[a.length-1]==null) a.pop(); return a; }
function listToArr(h){ const a=[]; while(h){ a.push(h.val); h=h.next; } return a; }
function clone(o){
  if(Array.isArray(o)) return o.map(clone);
  if(o instanceof TreeNode) return buildTree(treeToArr(o));
  if(o instanceof ListNode) return buildList(listToArr(o));
  return o;
}
// Canonical JSON string for comparison (TreeNode/ListNode -> array shape).
function canon(r){
  if(r===undefined || r===null) return JSON.stringify(null);
  if(r instanceof ListNode) return JSON.stringify(listToArr(r));
  if(r instanceof TreeNode) return JSON.stringify(treeToArr(r));
  try { return JSON.stringify(r); } catch(e){ return String(r); }
}

const cell = process.cwd();
const slug = path.basename(cell);
const ref  = path.join(cell, '..', '..', '..', 'reference', 'leetcode');
let out, wl, method, resolve;
try {
  out = JSON.parse(fs.readFileSync(path.join(ref,'outputs',slug+'.json'),'utf8'));
  wl  = JSON.parse(fs.readFileSync(path.join(ref,'workloads',slug+'.json'),'utf8'));
  method = String(wl.entry_point||'').split('.').pop();
  let __src = fs.readFileSync(process.env.VALIDATE_SOLUTION_FILE || path.join(cell,'solution.js'),'utf8');
  __src = __src.replace(/^\s*['"]use strict['"];?\s*/, '');  // strip leading use-strict (tsc emits it) so the resolver's direct eval stays non-strict
  // Resolve any top-level name (class/function/var) the solution declares.
  // A `class`/`let`/`const` declaration does NOT leak out of eval, so instead
  // capture a closure whose direct eval sees the eval-program lexical scope.
  resolve = eval(__src + '\n;(function(){ return function(__n){ try { return eval(__n); } catch(e){ return undefined; } }; })()');
} catch(e){ process.stderr.write(`VALIDATE slug=${slug} ERROR load: ${e}\n`); process.exit(2); }

const SolutionCls = resolve('Solution');
const hasSol = (typeof SolutionCls === 'function');
const randomized = (slug === 'random-pick-index');
// LeetCode accepts these answers in ANY order (special judge) -> multiset compare.
const UNORDERED = new Set(['uncommon-words-from-two-sentences','remove-invalid-parentheses','restore-the-array-from-adjacent-pairs']);
function unorderedEq(a, e){
  if(!Array.isArray(a) || !Array.isArray(e)) return canon(a)===canon(e);
  const k = xs => xs.map(canon).sort();
  const ka=k(a), ke=k(e);
  return ka.length===ke.length && ka.every((v,i)=>v===ke[i]);
}

function runCase(input){
  if('ops' in input && 'args' in input){
    const ops=input.ops, args=input.args;
    let Cls = resolve(ops[0]); if(typeof Cls !== 'function') Cls = hasSol ? SolutionCls : undefined;
    if(typeof Cls !== 'function') throw new Error('no class '+ops[0]);
    const nums = (randomized && args[0]) ? args[0][0] : null;
    const inst = new Cls(...clone(args[0]));
    const seq = [null];
    for(let i=1;i<ops.length;i++){
      let r = inst[ops[i]](...clone(args[i]));
      if(randomized && ops[i]==='pick' && typeof r==='number' && nums) r = nums[r];
      seq.push(r===undefined ? null : r);
    }
    return seq;
  }
  const base = Object.keys(input).map(k =>
      k==='root' ? buildTree(input[k]) : k==='head' ? buildList(input[k]) : input[k]);
  if(hasSol) return new SolutionCls()[method](...base);
  const fn = resolve(method);
  if(typeof fn !== 'function') throw new Error('no function '+method);
  return fn(...base);
}

// design/trace: a null in expected marks a void op (LeetCode discards its
// return); compare strictly only at value-returning positions.
function seqOk(actual, expected){
  if(!Array.isArray(actual) || !Array.isArray(expected) || actual.length!==expected.length) return false;
  for(let i=0;i<expected.length;i++){
    if(expected[i]===null) continue;
    if(canon(actual[i])!==canon(expected[i])) return false;
  }
  return true;
}
const cases = out.expected;
for(const c of cases){
  let actual;
  const isDesign = ('ops' in c.input && 'args' in c.input);
  try { actual = runCase(c.input); }
  catch(e){ process.stderr.write(`VALIDATE slug=${slug} RE case=${c.name} ${e}\n`); process.exit(3); }
  const ok = isDesign ? seqOk(actual, c.output) : (UNORDERED.has(slug) ? unorderedEq(actual, c.output) : (canon(actual) === canon(c.output)));
  if(!ok){
    process.stderr.write(`VALIDATE slug=${slug} FAIL case=${c.name} `
      + `expected=${canon(c.output).slice(0,120)} actual=${canon(actual).slice(0,120)}\n`);
    process.exit(1);
  }
}
process.stderr.write(`VALIDATE slug=${slug} PASS ncases=${cases.length}\n`);
process.exit(0);
