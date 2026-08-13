package main

// Reference Go solution for finding-mk-average.
import "sort"

type MKAverage struct {
    m, k   int
    stream []int
}

func Constructor(m int, k int) MKAverage {
    return MKAverage{m: m, k: k, stream: nil}
}
func (mk *MKAverage) AddElement(num int) { mk.stream = append(mk.stream, num) }
func (mk *MKAverage) CalculateMKAverage() int {
    if len(mk.stream) < mk.m { return -1 }
    w := make([]int, mk.m)
    copy(w, mk.stream[len(mk.stream)-mk.m:])
    sort.Ints(w)
    lo, hi := mk.k, mk.m - mk.k
    if hi <= lo { return -1 }
    sum := 0
    for i := lo; i < hi; i++ { sum += w[i] }
    return sum / (hi - lo)
}
