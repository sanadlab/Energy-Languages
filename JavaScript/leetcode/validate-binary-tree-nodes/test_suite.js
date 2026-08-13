// LC-energy test suite (JavaScript) — hardcoded single case.
const path = require('path');
const src = require('fs').readFileSync(path.join(__dirname,'solution.js'),'utf8');
eval(src);
const _lc = (typeof Solution !== 'undefined')
  ? new Solution().validateBinaryTreeNodes(20, [1,2,3,4,5], [1,2,3,4,5])
  : validateBinaryTreeNodes(20, [1,2,3,4,5], [1,2,3,4,5]);
