# Generic Ruby loop-harness for the cross-language transfer check.
# Reads the SAME shared JSON inputs as the Python/JS harnesses, loads the cell's
# solution.rb, and loops the call to a wall-time budget (checksum-consumed,
# iteration-counted). Ruby is dynamic, so plain-data args pass straight through;
# only tree/list/design need construction.
#
#   ruby harness.rb <budget_seconds> <case_index>   (run from the Ruby cell dir)
#   - slug derived from the cell directory name (Ruby/leetcode/<slug>/)
#   - inputs from ../../../reference/leetcode/{outputs,workloads}/<slug>.json
#   - prints CASE/ITERS/ACC/BEACON to STDERR (stdout stays empty -> validate ok)
#
# LeetCode Ruby methods are snake_case while the shared entry_point / design ops
# are camelCase, so method names are converted (Rails-style "underscore") with a
# respond_to? fallback to the original spelling.
require 'json'
require 'set' # LeetCode's Ruby runtime preloads stdlib 'set'; match that environment

# ---- node types the solutions expect (they only ever receive these) ----------
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
    s.gsub!(/([A-Z]+)([A-Z][a-z])/, '\1_\2') # acronym boundary: MKAverage -> MK_Average
    s.gsub!(/([a-z\d])([A-Z])/, '\1_\2')      # camel boundary:   addElement -> add_Element
    s.downcase
  end

  def build_tree(a)
    return nil if a.nil? || a.empty? || a[0].nil?
    root = TreeNode.new(a[0]); q = [root]; i = 1
    until i >= a.length || q.empty?
      n = q.shift
      if i < a.length
        lv = a[i]; i += 1
        if !lv.nil?; n.left = TreeNode.new(lv); q << n.left; end
      end
      if i < a.length
        rv = a[i]; i += 1
        if !rv.nil?; n.right = TreeNode.new(rv); q << n.right; end
      end
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
      if n.nil?; a << nil
      else; a << n.val; q << n.left; q << n.right; end
    end
    a.pop while !a.empty? && a[-1].nil?
    a
  end

  def list_to_arr(h)
    a = []
    while h; a << h.val; h = h.next; end
    a
  end

  def canon(r)
    case r
    when nil     then 'null'
    when TreeNode then tree_to_arr(r).to_json
    when ListNode then list_to_arr(r).to_json
    else
      begin; r.to_json; rescue StandardError; r.to_s; end
    end
  end

  MASK64 = (1 << 64) - 1
  def strhash(s)
    h = 0
    s.each_byte { |b| h = (h * 31 + b) & 0xFFFFFFFF }
    h
  end
  def fold(acc, r)
    (acc * 1000003 + strhash(canon(r))) & MASK64
  end

  # deep copy of plain data (numbers/strings/arrays/hashes/bools)
  def deep(x)
    Marshal.load(Marshal.dump(x))
  end

  # pick the actual Ruby method name (snake_case first, camel fallback)
  def resolve(obj, camel)
    snake = underscore(camel)
    return snake if obj.respond_to?(snake, true)
    return camel if obj.respond_to?(camel, true)
    snake
  end
end

# --------------------------------------------------------------------------- #
budget = Float(ARGV[0])
idx    = Integer(ARGV[1])
cell   = Dir.pwd
slug   = File.basename(cell)
ref    = File.join(cell, '..', '..', '..', 'reference', 'leetcode')

out   = JSON.parse(File.read(File.join(ref, 'outputs', "#{slug}.json")))
kase  = out['expected'][idx]
name  = kase['name']
input = kase['input']

# load the solution (top-level defs become private Object methods; classes -> constants)
prev_verbose = $VERBOSE
$VERBOSE = nil
load File.join(cell, 'solution.rb')
$VERBOSE = prev_verbose

warm = budget * 0.3
def now; Process.clock_gettime(Process::CLOCK_MONOTONIC); end

acc = 0
iters = 0
echo = ENV['HNS_ECHO']

if input.is_a?(Hash) && input.key?('ops') && input.key?('args')
  # ---- design-class replay: ops[0]=class, args[0]=ctor args, then method calls ----
  ops  = input['ops']
  args = input['args']
  klass = begin
            Object.const_get(ops[0])
          rescue NameError
            Object.const_get('Solution') # solution named the class differently
          end
  replay = lambda do |collect|
    inst = klass.new(*HNS.deep(args[0]))
    a = 0
    results = collect ? [nil] : nil
    (1...ops.length).each do |i|
      m = HNS.resolve(inst, ops[i])
      r = inst.send(m, *HNS.deep(args[i]))
      results << r if collect
      a = HNS.fold(a, r)
    end
    collect ? results : a
  end

  if echo
    STDERR.puts "RESULT=#{replay.call(true).to_json}"
  end
  # stateful replay -> args deep-copied each pass (kept); batch the clock read.
  wi = 0; t0 = now
  while now - t0 < warm; replay.call(false); wi += 1; end
  per = wi > 0 ? (now - t0) / wi : warm
  batch = per > 0 ? [[1, (0.002 / per).to_i].max, 4096].min : 4096
  tm = now
  while now - tm < budget - warm
    batch.times { acc = HNS.fold(acc, replay.call(false)) }
    iters += batch
  end
  meas = now - tm
  STDERR.puts "CASE=#{name} ITERS=#{iters} ACC=#{acc} MEAS_S=#{'%.6f' % meas} BEACON=design"
else
  # ---- generic single-method call ----
  wl     = JSON.parse(File.read(File.join(ref, 'workloads', "#{slug}.json")))
  ep     = wl['entry_point'].to_s
  camel  = ep.split('.').last
  keys   = input.is_a?(Hash) ? input.keys : []

  has_sol = defined?(Solution) && Solution.is_a?(Class)
  recv    = has_sol ? Solution.new : Object.new
  meth    = HNS.resolve(recv, camel)

  build_args = lambda do
    keys.map do |k|
      v = input[k]
      if k == 'root'    then HNS.build_tree(HNS.deep(v))
      elsif k == 'head' then HNS.build_list(HNS.deep(v))
      else HNS.deep(v)
      end
    end
  end
  # (1) detect mutation once; reuse deep-copied args when the solution leaves
  #     them untouched (HNS.deep per iteration was the dominant Ruby overhead).
  pristine = build_args.call
  snap = pristine.map { |x| HNS.canon(x) }.join("\x1e")
  probe = build_args.call
  beacon = recv.send(meth, *probe)
  mutated = probe.map { |x| HNS.canon(x) }.join("\x1e") != snap
  one = mutated ? lambda { recv.send(meth, *build_args.call) } : lambda { recv.send(meth, *pristine) }

  STDERR.puts "RESULT=#{HNS.canon(beacon)}" if echo
  # (3) estimate per-iter cost during warmup, then batch the wall-clock read
  wi = 0; t0 = now
  while now - t0 < warm; one.call; wi += 1; end
  per = wi > 0 ? (now - t0) / wi : warm
  batch = per > 0 ? [[1, (0.002 / per).to_i].max, 4096].min : 4096
  tm = now
  while now - tm < budget - warm
    batch.times { acc = HNS.fold(acc, one.call) }
    iters += batch
  end
  meas = now - tm
  STDERR.puts "CASE=#{name} ITERS=#{iters} ACC=#{acc} MEAS_S=#{'%.6f' % meas} BEACON=#{HNS.canon(beacon)[0, 80]}"
end
