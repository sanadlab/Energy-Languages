# Reference Ruby solution for design-a-stack-with-increment-operation.
class CustomStack
    def initialize(max_size)
        @max = max_size; @stack = []; @inc = []
    end
    def push(x)
        return unless @stack.length < @max
        @stack.push(x); @inc.push(0)
    end
    def pop()
        return -1 if @stack.empty?
        i = @stack.length - 1
        v = @stack[i] + @inc[i]
        @inc[i - 1] += @inc[i] if i > 0
        @stack.pop; @inc.pop
        v
    end
    def increment(k, val)
        i = [k, @stack.length].min - 1
        @inc[i] += val if i >= 0
    end
end
