// LC-energy test suite (JavaScript) — middle-of-the-linked-list.
function ListNode(val, next) { this.val = val; this.next = next || null; }
eval(require('fs').readFileSync(__dirname + '/solution.js', 'utf8'));

const h = new ListNode(1, new ListNode(2, new ListNode(3, new ListNode(4, new ListNode(5)))));
const _lc = (typeof Solution !== 'undefined')
  ? new Solution().middleNode(h)
  : middleNode(h);
if (_lc === null) console.log("null");
