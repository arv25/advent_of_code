# Day1
input = File.open('day2_input.txt').readlines

def line_to_tuple_helper(input)
  input.map do |line|
    x = line.split(":")
    y = x[0].split(' ')
    z = y[0].split('-')
    z.map(&:to_i).concat([y[1], x[1].chomp.strip])
  end
end

def problem1(input)
  tuples = line_to_tuple_helper(input)
  result = {}

  result[:answer] = tuples.reduce(0) do |memo, (min, max, letter, password)|
    memo += 1 if password.count(letter).between?(min, max)
    memo
  end

  result
end

def problem2(input)
  result = {}
  tuples = line_to_tuple_helper(input)

  result[:answer] = tuples.reduce(0) do |memo, (idx1, idx2, letter, password)|
    x = [password[idx1-1], password[idx2-1]]
    condition1 = x.any?{ |c| c == letter }
    condition2 = x.uniq.count == 2
    memo += 1 if condition1 && condition2
    memo
  end

  result
end

# -- Outputs --
puts "Problem1: #{problem1(input)}"
puts "Problem2: #{problem2(input)}"
