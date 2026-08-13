class Solution {
    validateBinaryTreeNodes(n: number, leftChild: number[], rightChild: number[]): boolean {
        const count = new Array(n).fill(0);
        
        for (let j = 0; j < n; j++) {
            const left = leftChild[j];
            const right = rightChild[j];
            
            if (left !== -1) {
                if (count[left] > 0) return false;
                count[left] = 1;
            }
            
            if (right !== -1) {
                if (count[right] > 0) return false;
                count[right] = 1;
            }
        }
        
        let root = -1;
        for (let i = 0; i < n; i++) {
            if (count[i] === 0) {
                if (root === -1) root = i;
                else return false;
            }
        }
        
        if (root === -1) return false;
        
        const visited = new Array(n).fill(false);
        const queue: number[] = [root];
        visited[root] = true;
        let nodesVisited = 1;
        
        while (queue.length > 0) {
            const u = queue.shift()!;
            const left = leftChild[u];
            const right = rightChild[u];
            
            if (left !== -1 && !visited[left]) {
                visited[left] = true;
                nodesVisited++;
                queue.push(left);
            }
            
            if (right !== -1 && !visited[right]) {
                visited[right] = true;
                nodesVisited++;
                queue.push(right);
            }
        }
        
        return nodesVisited === n;
    }
}// LC-energy test suite (TypeScript) — hardcoded single case.
let _lc_test_result: any;
// Shape-agnostic call: LC accepted solutions are sometimes a
// `class Solution` and sometimes a bare top-level function. eval
// keeps tsc from static-erroring on whichever name is absent.
try { _lc_test_result = eval('new Solution().validateBinaryTreeNodes(20, [1,2,3,4,5], [1,2,3,4,5])'); }
catch (_e) { _lc_test_result = eval('validateBinaryTreeNodes(20, [1,2,3,4,5], [1,2,3,4,5])'); }
if (_lc_test_result === undefined || _lc_test_result === null) {
    console.log('void return');
}
