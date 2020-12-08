# Day7
#input = File.open('day7_input_eg.txt').readlines.map(&:chomp)
input = File.open('day7_input.txt').readlines.map(&:chomp)

require 'ostruct'

def node(value)
  OpenStruct.new(
    {
      value: value,
      children: [],
      counts: {}
    })
end

def create_nodes(input)
  nodes = {  }

  input.each do |line|
    line = line[0..line.size-2] # get rid of trailing period

    if line =~ /(.*)contain(.*)/
      parent = $1.chomp.strip
      parent = parent[0..parent.size-2] # bags => bag
      nodes[parent] = node(parent) unless nodes[parent]

      next if $2.chomp.strip == 'no other bags' # means no children
      children = $2.split(',').map { |s| s.gsub('bags', 'bag') } # keep names singular always
      children.map do |child|
        if child =~ /(\d) (.*)/
          child = $2.chomp.strip
          nodes[child] = node(child) unless nodes[child]
          nodes[parent].children.push(nodes[child])
          nodes[parent].counts[child] = $1.to_i
        end
      end
    end
  end

  nodes
end

def contains_color?(node, color="shiny gold")
  node.children.any? { |n| n.value.include?(color) } ||
    node.children.map { |c| contains_color?(c, color) }.reduce(&:|)
end

def problem1(input)
  nodes = create_nodes(input)

  nodes.inject(0) do |memo, (_name, node)|
    memo += 1 if contains_color?(node, "shiny gold")
    memo
  end
end


def count_included_bags(node)
  return 0 unless node.children.size > 0
  node.children.map do |child|
    node.counts[child.value] + (node.counts[child.value] * count_included_bags(child))
  end.reduce(&:+)
end

def problem2(input)
  nodes = create_nodes(input)
  count_included_bags(nodes['shiny gold bag'])
end

# -- Outputs --
puts "Problem1: #{problem1(input)}"
puts "Problem2: #{problem2(input)}"
