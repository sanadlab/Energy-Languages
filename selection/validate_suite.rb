# Full-suite correctness validator (Ruby). Runs solution.rb against EVERY
# reference case and compares each result to the expected output. Run FROM the
# cell dir:  ruby ../../../selection/validate_suite.rb
# Reuses harness.rb's tree/list/canon/name-resolution logic so correctness
# judges the exact same shared inputs the measurement harness does.
# Prints one VALIDATE line to STDERR. Exit: 0 Accepted, 1 Wrong Answer,
# 3 Runtime Error, 2 setup error.
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
end

def seq_ok(actual, expected)
  return false unless actual.is_a?(Array) && expected.is_a?(Array) && actual.length == expected.length
  # design/trace: a null in expected marks a void op (LeetCode discards its
  # return); compare strictly only at value-returning positions.
  actual.each_index.all? { |i| expected[i].nil? || HNS.canon(actual[i]) == HNS.canon(expected[i]) }
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
rescue StandardError => e
  STDERR.puts "VALIDATE slug=#{slug} ERROR load: #{e}"; exit 2
end

has_sol   = defined?(Solution) && Solution.is_a?(Class)
randomized = (slug == 'random-pick-index')
# LeetCode accepts these answers in ANY order (special judge) -> multiset compare.
UNORDERED = ['uncommon-words-from-two-sentences', 'remove-invalid-parentheses', 'restore-the-array-from-adjacent-pairs']
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
  recv = has_sol ? Solution.new : Object.new
  meth = HNS.resolve(recv, camel)
  base = input.keys.map do |k|
    v = input[k]
    if k == 'root' then HNS.build_tree(HNS.deep(v))
    elsif k == 'head' then HNS.build_list(HNS.deep(v))
    else HNS.deep(v) end
  end
  recv.send(meth, *base)
end

out['expected'].each do |c|
  name = c['name']
  inp  = c['input']
  is_design = inp.is_a?(Hash) && inp.key?('ops') && inp.key?('args')
  begin
    actual = run_case(inp, camel, has_sol, randomized)
  rescue StandardError, ScriptError => e
    STDERR.puts "VALIDATE slug=#{slug} RE case=#{name} #{e.class}: #{e}"; exit 3
  end
  ok = if is_design then seq_ok(actual, c['output'])
       elsif UNORDERED.include?(slug) then unordered_eq(actual, c['output'])
       else HNS.canon(actual) == HNS.canon(c['output']) end
  unless ok
    STDERR.puts "VALIDATE slug=#{slug} FAIL case=#{name} " \
      "expected=#{HNS.canon(c['output'])[0,120]} actual=#{HNS.canon(actual)[0,120]}"
    exit 1
  end
end
STDERR.puts "VALIDATE slug=#{slug} PASS ncases=#{out['expected'].length}"
exit 0
