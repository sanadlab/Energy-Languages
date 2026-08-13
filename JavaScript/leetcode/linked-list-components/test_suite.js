// LC-energy test suite (JavaScript) — linked-list-components.
function ListNode(val, next) {
    this.val = val;
    this.next = next || null;
}
eval(require('fs').readFileSync(__dirname + '/solution.js', 'utf8'));

const h = new ListNode(0, new ListNode(1, new ListNode(2, new ListNode(3))));
const _lc = (typeof Solution !== 'undefined')
  ? new Solution().numComponents(h, [0, 1, 3])
  : numComponents(h, [0, 1, 3]);
if (_lc < 0) console.log(_lc);
