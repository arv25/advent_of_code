# Day9
#preamble, input = [5, File.open('day9_input_eg.txt').readlines.map(&:to_i)]
preamble,input = [25, File.open('day9_input.txt').readlines.map(&:to_i)]

require 'ostruct'

def is_sum_of_previous?(lon, preamble)
  fail "insufficient list of numbers" if lon.size - 1 < preamble
  fail unless preamble

  newest_num = lon.last
  truncated_lon = lon.reverse[1..preamble].reverse

  truncated_lon.any? do |n|
    difference = newest_num - n
    lon.reverse[1..preamble].any? { |m| m == difference }
  end
end

def problem1(input, preamble)
  input.detect.with_index do |num, idx|
    next if idx < preamble
    !is_sum_of_previous?(input[0..idx], preamble)
  end
end


def problem2(input, target)
  results = { }
  limit_idx = input.find_index(target)
  lon = input[0...limit_idx] # assume we're working with nums previous to the target

  bounds = lon.each_with_index do |_, i|
    upper = lon[i+1...limit_idx].detect.with_index do |_, j|
      sum = lon[i..j+i].reduce(&:+)
      break j+i if sum == target
      break if sum > target
    end

    break [i, upper] if upper
  end

  results[:all_addends] = input[bounds.first..bounds.last] # range of addends
  results[:final_addends] = [results[:all_addends].min, results[:all_addends].max]
  results[:answer] = results[:final_addends].reduce(&:+)
  results
end

# -- Outputs --
target = problem1(input, preamble)
puts "Problem1: #{target}"
puts "Problem2: #{problem2(input, target)}"
