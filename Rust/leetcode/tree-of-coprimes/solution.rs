impl Solution {
    pub fn get_coprimes(nums: Vec<i32>, edges: Vec<Vec<i32>>) -> Vec<i32> {
        let n = nums.len();
        let mut ans = vec![-1i32; n];

        let mut adj: Vec<Vec<usize>> = vec![Vec::new(); n];
        for e in &edges {
            if e.len() < 2 {
                continue;
            }
            let u = e[0];
            let v = e[1];
            if u >= 0 && (u as usize) < n && v >= 0 && (v as usize) < n {
                adj[u as usize].push(v as usize);
                adj[v as usize].push(u as usize);
            }
        }

        fn gcd(mut a: i32, mut b: i32) -> i32 {
            while b != 0 {
                let t = b;
                b = a % b;
                a = t;
            }
            a
        }

        // For each value 1..50, values coprime with it.
        let mut coprime: Vec<Vec<usize>> = vec![Vec::new(); 51];
        for a in 1..=50i32 {
            for b in 1..=50i32 {
                if gcd(a, b) == 1 {
                    coprime[a as usize].push(b as usize);
                }
            }
        }

        // Ancestor stacks indexed by VALUE (size 51).
        let mut depth_stack: Vec<Vec<i32>> = vec![Vec::new(); 51];
        let mut node_stack: Vec<Vec<i32>> = vec![Vec::new(); 51];
        if n == 0 {
            return ans;
        }

        // Iterative DFS with enter/exit markers.
        let mut stack: Vec<(usize, i32, i32, bool)> = vec![(0, -1, 0, false)];
        while let Some((node, parent, depth, processed)) = stack.pop() {
            let val = nums[node] as usize;
            if processed {
                depth_stack[val].pop();
                node_stack[val].pop();
                continue;
            }
            let mut best_depth = -1i32;
            let mut best_node = -1i32;
            for &cv in &coprime[val] {
                if let Some(&d) = depth_stack[cv].last() {
                    if d > best_depth {
                        best_depth = d;
                        best_node = *node_stack[cv].last().unwrap();
                    }
                }
            }
            ans[node] = best_node;
            stack.push((node, parent, depth, true));
            depth_stack[val].push(depth);
            node_stack[val].push(node as i32);
            for &nb in &adj[node] {
                if nb as i32 != parent {
                    stack.push((nb, node as i32, depth + 1, false));
                }
            }
        }
        ans
    }
}
