// JavaScript loop-harness for the cross-language transfer check: the shared
// Node loop (harness_node_common.js) on the solution's source as it is.
//
//   node harness.js <budget_seconds> <case_index>   (run from the JS cell dir)
//   prints CASE/ITERS/ACC/MEAS_S/BEACON to STDERR (stdout stays empty).
const fs = require('fs');
const path = require('path');

require('./harness_node_common.js').run(
  fs.readFileSync(path.join(process.cwd(), 'solution.js'), 'utf8'));
