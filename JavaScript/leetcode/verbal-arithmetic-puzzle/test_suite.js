// LC-energy test suite (JavaScript) — hardcoded single case.
const path = require('path');
const src = require('fs').readFileSync(path.join(__dirname,'solution.js'),'utf8');
eval(src);
const _lc = (typeof Solution !== 'undefined')
  ? new Solution().isSolvable(["a","b","c"], "abcde")
  : isSolvable(["a","b","c"], "abcde");
