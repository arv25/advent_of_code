# Day1
input = File.open('day1_input.txt').readlines.map(&:to_i)

def problem1(input)
  result = { n: 0, m: 0, sum: 0, answer: 0 }

  input.each do |n|
    input.each do |m|
      if (n+m == 2020)
        result[:n] = n
        result[:m] = m
        result[:sum] = n+m
        result[:answer] = n*m
        break
      end
      break if result[:answer] != 0
    end
  end

  result
end

def problem2(input)
  result = { n: 0, m: 0, p: 0, sum: 0, answer: 0 }

  input.each do |n|
    input.each do |m|
      input.each do |p|
        if (n+m+p == 2020)
          result[:n] = n
          result[:m] = m
          result[:p] = p
          result[:sum] = n+m+p
          result[:answer] = n*m*p
          break
        end
        break if result[:answer] != 0
      end
      break if result[:answer] != 0
    end
  end

  result
end

# -- Outputs --
puts "Problem1: #{problem1(input)}"
puts "Problem2: #{problem2(input)}"
