class Solution {
  evaluate(s: string, knowledge: string[][]): string {
    const map = new Map<string, string>();
    for (const [key, value] of knowledge) {
      map.set(key, value);
    }

    const regex = /\(([^)]+)\)/g;
    return s.replace(regex, (match) => {
      const key = match.substring(1, match.length - 1);
      return map.get(key) ?? '?';
    });
  }
}