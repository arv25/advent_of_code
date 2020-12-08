# Day6
#input = File.open('day6_input_eg.txt').read
input = File.open('day6_input.txt').read


def problem1(input)
  groups = input.split("\n\n")
  groups = groups.map{ |g| g.tr("\n", '') }
  yesses_by_group = groups.map{|g| g.split('') }
  yesses_by_group.map(&:uniq).map(&:size).reduce(&:+)
end


def problem2(input)
  groups = input.split("\n\n")
  intersection = groups.map do |g|
    g.split("\n").map{ |w| w.split('') }.reduce(&:&)
  end

  intersection.map(&:size).reduce(&:+)
end

# -- Outputs --
puts "Problem1: #{problem1(input)}"
puts "Problem2: #{problem2(input)}"
