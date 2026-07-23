// LC-energy test suite (JavaScript) — hardcoded single case.
const path = require('path');
const src = require('fs').readFileSync(path.join(__dirname,'solution.js'),'utf8');
eval(src);
const _ = canPartitionKSubsets([1,2,3,4,5], 20);
