// LC-energy test suite (JavaScript) — hardcoded single case.
const path = require('path');
const src = require('fs').readFileSync(path.join(__dirname,'solution.js'),'utf8');
eval(src);
const _lc = (typeof Solution !== 'undefined')
  ? new Solution().minCost(20, [[1,2],[3,4]], [1,2,3,4,5])
  : minCost(20, [[1,2],[3,4]], [1,2,3,4,5]);
