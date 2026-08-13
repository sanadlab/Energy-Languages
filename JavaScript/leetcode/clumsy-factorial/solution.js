var clumsy = function(n) {
    let stack = [n];
    n--;
    let index = 0; // to cycle through *, /, +, -
    
    while (n > 0) {
        if (index % 4 === 0) {
            // multiply
            stack.push(stack.pop() * n);
        } else if (index % 4 === 1) {
            // divide (floor division)
            let top = stack.pop();
            // floor division for positive numbers
            stack.push(Math.trunc(top / n));
        } else if (index % 4 === 2) {
            // add
            stack.push(n);
        } else {
            // subtract
            stack.push(-n);
        }
        n--;
        index++;
    }
    
    return stack.reduce((a,b) => a + b, 0);
};