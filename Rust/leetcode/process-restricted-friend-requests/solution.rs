impl Solution {
    pub fn friend_requests(n: i32, restrictions: Vec<Vec<i32>>, requests: Vec<Vec<i32>>) -> Vec<bool> {
        let n = n as usize;
        let mut parent: Vec<usize> = (0..n).collect();

        fn find(parent: &mut Vec<usize>, mut x: usize) -> usize {
            while parent[x] != x {
                parent[x] = parent[parent[x]];
                x = parent[x];
            }
            x
        }

        let mut res: Vec<bool> = Vec::with_capacity(requests.len());
        for req in requests.iter() {
            let u = req[0] as usize;
            let v = req[1] as usize;
            let pu = find(&mut parent, u);
            let pv = find(&mut parent, v);
            if pu == pv {
                res.push(true);
                continue;
            }
            let mut ok = true;
            for r in restrictions.iter() {
                let px = find(&mut parent, r[0] as usize);
                let py = find(&mut parent, r[1] as usize);
                if (px == pu && py == pv) || (px == pv && py == pu) {
                    ok = false;
                    break;
                }
            }
            if ok {
                parent[pu] = pv;
                res.push(true);
            } else {
                res.push(false);
            }
        }
        res
    }
}
