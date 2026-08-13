class Solution
  def evaluate(s, knowledge)
    knowledge_hash = knowledge.map { |k| [k[0], k[1]] }.to_h
    s.gsub(/\(([^)]+)\)/) { knowledge_hash[$1] || '?' }
  end
end