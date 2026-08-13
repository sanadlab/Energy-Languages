function judgeCircle(moves: string): boolean {
    let x = 0, y = 0;
    for (const move of moves) {
        switch (move) {
            case 'R': x++; break;
            case 'L': x--; break;
            case 'U': y++; break;
            case 'D': y--; break;
        }
    }
    return x === 0 && y === 0;
}
