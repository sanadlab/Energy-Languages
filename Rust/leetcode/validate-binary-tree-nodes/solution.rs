impl Solution {
    pub fn validate_binary_tree_nodes(n: i32, left_child: Vec<i32>, right_child: Vec<i32>) -> bool {
        let n = n as usize;
        let m = left_child.len().min(right_child.len());
        let mut indeg = vec![0i32; n];
        for i in 0..m {
            for &c in &[left_child[i], right_child[i]] {
                if c != -1 {
                    if c < 0 || c as usize >= n {
                        return false;
                    }
                    indeg[c as usize] += 1;
                    if indeg[c as usize] > 1 {
                        return false;
                    }
                }
            }
        }
        let mut root: i32 = -1;
        for i in 0..n {
            if indeg[i] == 0 {
                if root != -1 {
                    return false;
                }
                root = i as i32;
            }
        }
        if root == -1 {
            return false;
        }
        let mut visited = vec![false; n];
        let mut stack: Vec<usize> = vec![root as usize];
        let mut count = 0usize;
        while let Some(node) = stack.pop() {
            if visited[node] {
                return false;
            }
            visited[node] = true;
            count += 1;
            if node < m {
                for &c in &[left_child[node], right_child[node]] {
                    if c != -1 {
                        stack.push(c as usize);
                    }
                }
            }
        }
        count == n
    }
}
