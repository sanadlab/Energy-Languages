from typing import List
from collections import Counter


class Solution:
    def findWords(self, board: List[List[str]], words: List[str]) -> List[str]:
        m, n = len(board), len(board[0])
        total_cells = m * n

        board_count = Counter()
        for row in board:
            board_count.update(row)

        trie = {}
        END = "#"

        for word in words:
            if len(word) > total_cells:
                continue

            need = {}
            possible = True
            for ch in word:
                need[ch] = need.get(ch, 0) + 1
                if need[ch] > board_count.get(ch, 0):
                    possible = False
                    break

            if not possible:
                continue

            path = word
            if board_count[word[0]] > board_count[word[-1]]:
                path = word[::-1]

            node = trie
            for ch in path:
                node = node.setdefault(ch, {})
            node[END] = word

        res = []
        dirs = ((1, 0), (-1, 0), (0, 1), (0, -1))

        def dfs(r: int, c: int, parent: dict) -> None:
            ch = board[r][c]
            node = parent.get(ch)
            if node is None:
                return

            found = node.pop(END, None)
            if found is not None:
                res.append(found)

            board[r][c] = ""

            for dr, dc in dirs:
                nr, nc = r + dr, c + dc
                if 0 <= nr < m and 0 <= nc < n and board[nr][nc] in node:
                    dfs(nr, nc, node)

            board[r][c] = ch

            if not node:
                parent.pop(ch)

        for i in range(m):
            for j in range(n):
                if board[i][j] in trie:
                    dfs(i, j, trie)

        return res
