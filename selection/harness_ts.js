// TypeScript loop-harness for the cross-language transfer check: transpile
// solution.ts -> JS (type-stripping via the TS compiler API, no type-checking),
// then measure it with the shared Node loop (harness_node_common.js), exactly
// as harness.js measures JavaScript.
//
//   node harness_ts.js <budget_seconds> <case_index>   (run from the TS cell dir)
//   node harness_ts.js --build      (transpile once into .perf_build/solution.js)
//   prints CASE/ITERS/ACC/MEAS_S/BEACON to STDERR (stdout stays empty).
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
// Loaded lazily: a run on a prebuilt solution (PERFARENA_TS_PREBUILT=1) never
// loads the compiler, so the memory pass does not measure it.
let ts = null;
function transpile(src) {
  if (!ts) ts = loadTS();
  return ts.transpileModule(src, {
    compilerOptions: {
      // ES2022 runs natively on the runner's Node (20), so the output keeps
      // the solution's own `?.`, `??`, class fields, and #private fields
      // instead of down-levelled helpers (#private became WeakMap calls).
      // Strict mode is explicit because the TS default differs between TS 5
      // (sloppy) and TS 6 (strict); strict is TypeScript's direction.
      target: ts.ScriptTarget.ES2022,
      alwaysStrict: true,
      module: ts.ModuleKind.CommonJS,
      removeComments: false,
    },
  }).outputText;
}

const cell = process.cwd();
// `node harness_ts.js --build` transpiles solution.ts once into .perf_build/
// for run_harness.sh build mode, and exits without running anything.
const PREBUILT = path.join(cell, '.perf_build', 'solution.js');
if (process.argv[2] === '--build') {
  fs.mkdirSync(path.dirname(PREBUILT), { recursive: true });
  fs.writeFileSync(PREBUILT, transpile(fs.readFileSync(path.join(cell, 'solution.ts'), 'utf8')));
  process.exit(0);
}
// The solution's JavaScript: prebuilt by build mode, else transpiled now.
let jsSrc;
if (process.env.PERFARENA_TS_PREBUILT === '1') {
  if (!fs.existsSync(PREBUILT)) { process.stderr.write('run mode: no prebuilt TypeScript; run the build mode first\n'); process.exit(2); }
  jsSrc = fs.readFileSync(PREBUILT, 'utf8');
} else {
  jsSrc = transpile(fs.readFileSync(path.join(cell,'solution.ts'),'utf8'));
}
require('./harness_node_common.js').run(jsSrc);
