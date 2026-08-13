package main


func ladderLength(beginWord string, endWord string, wordList []string) int {
	wordSet := make(map[string]bool)
	for _, w := range wordList {
		wordSet[w] = true
	}
	if !wordSet[endWord] {
		return 0
	}

	// BFS initialization
	queue := []string{beginWord}
	visited := make(map[string]bool)
	visited[beginWord] = true
	level := 1

	for len(queue) > 0 {
		nextQueue := []string{}
		for _, word := range queue {
			if word == endWord {
				return level
			}
			// Try all possible one-letter transformations
			wordBytes := []byte(word)
			for i := 0; i < len(wordBytes); i++ {
				originalChar := wordBytes[i]
				for c := byte('a'); c <= 'z'; c++ {
					if c == originalChar {
						continue
					}
					wordBytes[i] = c
					nextWord := string(wordBytes)
					if wordSet[nextWord] && !visited[nextWord] {
						visited[nextWord] = true
						nextQueue = append(nextQueue, nextWord)
					}
				}
				wordBytes[i] = originalChar
			}
		}
		queue = nextQueue
		level++
	}
	return 0
}
