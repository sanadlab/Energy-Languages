// LC-energy test suite (JavaScript) — hardcoded single case.
const path = require('path');
const src = require('fs').readFileSync(path.join(__dirname,'solution.js'),'utf8');
eval(src);
const _lc = (typeof Solution !== 'undefined')
  ? new Solution().numFactoredBinaryTrees([1,2,3,4,5])
  : numFactoredBinaryTrees([1,2,3,4,5]);
