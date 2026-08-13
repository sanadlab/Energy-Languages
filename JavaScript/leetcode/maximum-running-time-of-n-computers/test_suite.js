// LC-energy test suite (JavaScript) — hardcoded single case.
const path = require('path');
const src = require('fs').readFileSync(path.join(__dirname,'solution.js'),'utf8');
eval(src);
const _lc = (typeof Solution !== 'undefined')
  ? new Solution().maxRunTime(20, [1,2,3,4,5])
  : maxRunTime(20, [1,2,3,4,5]);
