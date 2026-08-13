// LC-energy test suite (JavaScript) — hardcoded single case.
const path = require('path');
const src = require('fs').readFileSync(path.join(__dirname,'solution.js'),'utf8');
eval(src);
const _lc = (typeof Solution !== 'undefined')
  ? new Solution().findKDistantIndices([1,2,3,4,5], 20, 20)
  : findKDistantIndices([1,2,3,4,5], 20, 20);
