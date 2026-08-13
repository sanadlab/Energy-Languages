impl Solution {
    pub fn clumsy(n: i32) -> i32 {
        let mut stack = Vec::new();
        stack.push(n);
        let mut n = n - 1;
        let mut i = 0; // operation index: 0->*, 1->/, 2->+, 3->-
        
        while n > 0 {
            match i % 4 {
                0 => { // multiply
                    let top = stack.pop().unwrap();
                    stack.push(top * n);
                }
                1 => { // divide (floor division)
                    let top = stack.pop().unwrap();
                    stack.push(top / n);
                }
                2 => { // add
                    stack.push(n);
                }
                3 => { // subtract
                    stack.push(-n);
                }
                _ => unreachable!(),
            }
            n -= 1;
            i += 1;
        }
        
        stack.iter().sum()
    }
}