class StreamChecker
    def initialize(words)
        @root = {}
        @stream = []
        @max_len = 0
        words.each do |w|
            node = @root
            (w.length - 1).downto(0) do |i|
                ch = w[i]
                node[ch] ||= {}
                node = node[ch]
            end
            node[:word] = true
            @max_len = w.length if w.length > @max_len
        end
    end

    def query(letter)
        @stream << letter
        node = @root
        n = @stream.length
        step = 0
        while step < @max_len && step < n
            ch = @stream[n - 1 - step]
            return false unless node.key?(ch)
            node = node[ch]
            return true if node[:word]
            step += 1
        end
        false
    end
end
