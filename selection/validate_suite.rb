# Full-suite correctness validator (Ruby). Runs solution.rb against EVERY
# reference case and compares each result to the expected output. Run FROM the
# cell dir:  ruby ../../../selection/validate_suite.rb
# Reuses harness.rb's tree/list/canon/name-resolution logic so correctness
# judges the exact same shared inputs the measurement harness does.
# Prints one VALIDATE line to STDERR. Exit: 0 Accepted, 1 Wrong Answer,
# 3 Runtime Error, 2 the solution cannot be loaded (syntax error) or setup error.
require 'json'
require 'set'

class TreeNode
  attr_accessor :val, :left, :right
  def initialize(v); @val = v; end
end
class ListNode
  attr_accessor :val, :next
  def initialize(v); @val = v; end
end

module HNS
  module_function
  def underscore(s)
    s = s.to_s.dup
    s.gsub!(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
    s.gsub!(/([a-z\d])([A-Z])/, '\1_\2')
    s.downcase
  end
  def build_tree(a)
    return nil if a.nil? || a.empty? || a[0].nil?
    root = TreeNode.new(a[0]); q = [root]; i = 1
    until i >= a.length || q.empty?
      n = q.shift
      if i < a.length; lv = a[i]; i += 1; (n.left = TreeNode.new(lv); q << n.left) unless lv.nil?; end
      if i < a.length; rv = a[i]; i += 1; (n.right = TreeNode.new(rv); q << n.right) unless rv.nil?; end
    end
    root
  end
  def build_list(a)
    return nil if a.nil? || a.empty?
    head = ListNode.new(a[0]); cur = head
    a[1..-1].each { |v| cur.next = ListNode.new(v); cur = cur.next }
    head
  end
  def tree_to_arr(r)
    a = []; q = [r]
    until q.empty?
      n = q.shift
      if n.nil?; a << nil else; a << n.val; q << n.left; q << n.right; end
    end
    a.pop while !a.empty? && a[-1].nil?
    a
  end
  def list_to_arr(h); a = []; while h; a << h.val; h = h.next; end; a; end
  def normfloat(x)
    case x
    when Float then (x.finite? && x == x.to_i) ? x.to_i : x
    when Array then x.map { |e| normfloat(e) }
    when Hash  then x.transform_values { |e| normfloat(e) }
    else x
    end
  end
  def canon(r)
    case r
    when nil      then 'null'
    when TreeNode then tree_to_arr(r).to_json
    when ListNode then list_to_arr(r).to_json
    else (begin; normfloat(r).to_json; rescue StandardError; r.to_s; end)
    end
  end
  def deep(x); Marshal.load(Marshal.dump(x)); end
  def resolve(obj, camel)
    snake = underscore(camel)
    return snake if obj.respond_to?(snake, true)
    return camel if obj.respond_to?(camel, true)
    snake
  end
  # Receiver and method name of a plain (non-design) problem. A `def self.x`
  # inside `class Solution` is a method of the class, not of an instance:
  # LeetCode's dispatch lifts the class body to top level, so it works there.
  def receiver(has_sol, camel)
    recv = has_sol ? Solution.new : Object.new
    if has_sol && !recv.respond_to?(resolve(recv, camel), true) &&
       Solution.respond_to?(resolve(Solution, camel), true)
      recv = Solution
    end
    [recv, resolve(recv, camel)]
  end
  # Do two results match? Equal canon forms match. Otherwise numbers match when
  # one of them is a non-integer float and they differ by at most 1e-5
  # (LeetCode accepts answers within 1e-5 on its float problems); arrays and
  # hashes match element by element; everything else must be equal.
  def same(a, e)
    return true if canon(a) == canon(e)
    num_close(JSON.parse("[#{canon(a)}]")[0], JSON.parse("[#{canon(e)}]")[0])
  rescue StandardError
    false
  end
  def num_close(a, e)
    if a.is_a?(Numeric) && e.is_a?(Numeric)
      a == e || ((a.is_a?(Float) || e.is_a?(Float)) && (a - e).abs <= 1e-5)
    elsif a.is_a?(Array) && e.is_a?(Array)
      a.length == e.length && a.each_index.all? { |i| num_close(a[i], e[i]) }
    elsif a.is_a?(Hash) && e.is_a?(Hash)
      a.keys.sort == e.keys.sort && a.keys.all? { |k| num_close(a[k], e[k]) }
    else
      a == e
    end
  end
end

def seq_ok(actual, expected)
  return false unless actual.is_a?(Array) && expected.is_a?(Array) && actual.length == expected.length
  # design/trace: a null in expected marks a void op (LeetCode discards its
  # return); compare strictly only at value-returning positions.
  actual.each_index.all? { |i| expected[i].nil? || HNS.same(actual[i], expected[i]) }
end

cell = Dir.pwd
slug = File.basename(cell)
ref  = File.join(cell, '..', '..', '..', 'reference', 'leetcode')

begin
  out   = JSON.parse(File.read(File.join(ref, 'outputs',   "#{slug}.json")))
  wl    = JSON.parse(File.read(File.join(ref, 'workloads', "#{slug}.json")))
  camel = wl['entry_point'].to_s.split('.').last
  prev = $VERBOSE; $VERBOSE = nil
  load File.join(cell, 'solution.rb')
  $VERBOSE = prev
rescue StandardError, ScriptError => e
  # ScriptError: SyntaxError, LoadError (not a StandardError) -> Compile Error
  STDERR.puts "VALIDATE slug=#{slug} ERROR load: #{e.class}: #{e}"; exit 2
end

has_sol   = defined?(Solution) && Solution.is_a?(Class)
randomized = (slug == 'random-pick-index')
# LeetCode accepts these answers in ANY order (special judge) -> multiset compare.
UNORDERED = ['uncommon-words-from-two-sentences', 'remove-invalid-parentheses', 'restore-the-array-from-adjacent-pairs', 'ambiguous-coordinates']
def unordered_eq(a, e)
  return HNS.canon(a) == HNS.canon(e) unless a.is_a?(Array) && e.is_a?(Array)
  a.map { |x| HNS.canon(x) }.sort == e.map { |x| HNS.canon(x) }.sort
end

def run_case(input, camel, has_sol, randomized)
  if input.is_a?(Hash) && input.key?('ops') && input.key?('args')
    ops = input['ops']; args = input['args']
    klass = if Object.const_defined?(ops[0], false) then Object.const_get(ops[0])
            elsif Object.const_defined?('Solution', false) then Object.const_get('Solution')
            else raise "no class #{ops[0]}" end
    nums = (randomized && args[0]) ? args[0][0] : nil
    inst = klass.new(*HNS.deep(args[0]))
    seq = [nil]
    (1...ops.length).each do |i|
      m = HNS.resolve(inst, ops[i])
      r = inst.send(m, *HNS.deep(args[i]))
      r = nums[r] if randomized && ops[i] == 'pick' && r.is_a?(Integer) && nums
      seq << r
    end
    return seq
  end
  recv, meth = HNS.receiver(has_sol, camel)
  base = input.keys.map do |k|
    v = input[k]
    if k == 'root' then HNS.build_tree(HNS.deep(v))
    elsif k == 'head' then HNS.build_list(HNS.deep(v))
    else HNS.deep(v) end
  end
  recv.send(meth, *base)
end

__total = out['expected'].length
out['expected'].each_with_index do |c, __i|
  name = c['name']
  inp  = c['input']
  is_design = inp.is_a?(Hash) && inp.key?('ops') && inp.key?('args')
  begin
    actual = run_case(inp, camel, has_sol, randomized)
  rescue SystemExit
    raise                       # the solution ended the process itself
  rescue Exception => e         # also SystemStackError, NoMemoryError, ScriptError
    STDERR.puts "VALIDATE slug=#{slug} RE case=#{name} passed=#{__i} ncases=#{__total} #{e.class}: #{e}"; exit 3
  end
  ok = if is_design then seq_ok(actual, c['output'])
       elsif UNORDERED.include?(slug) then unordered_eq(actual, c['output'])
       else HNS.same(actual, c['output']) end
  unless ok
    STDERR.puts "VALIDATE slug=#{slug} FAIL case=#{name} passed=#{__i} ncases=#{__total} " \
      "expected=#{HNS.canon(c['output'])[0,120]} actual=#{HNS.canon(actual)[0,120]}"
    exit 1
  end
end
STDERR.puts "VALIDATE slug=#{slug} PASS ncases=#{__total} passed=#{__total}"
exit 0
