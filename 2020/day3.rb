# Day3
# input = File.open('day3_input_eg.txt').readlines.map(&:chomp)
input = File.open('day3_input.txt').readlines.map(&:chomp)

# simulates being able to traverse a fixed length string as if it repeated indefinitely.
def nextWrappedIndex(startIdx, line, step=3)
  idxWithStep = startIdx + step
  idxWithStep > (line.size - 1) ? idxWithStep % line.size : idxWithStep
end

def problem1(input, step=3)
  result = { trees: 0 }
  charIdx = step #really starting from second line.

  input.each_with_index do |line, lineIdx|
    #first line is starting point, so there's never a tree
    next if lineIdx == 0

    # puts "L#{lineIdx+1}: #{charIdx} - #{line[charIdx]}"
    result[:trees] += 1 if line[charIdx] == '#'
    charIdx = nextWrappedIndex(charIdx, line, step)
  end

  result
end

def problem2(input)
  answers = [
    problem2_worker(input, 1, 1),
    problem2_worker(input, 1, 3),
    problem2_worker(input, 1, 5),
    problem2_worker(input, 1, 7),
    problem2_worker(input, 2, 1)
  ]
  {
    answer_collection: answers,
    final_answer: answers.map{ |e| e[:trees] }.reduce(:*)
  }
end

def problem2_worker(input, lineStep, charStep)
  result = { trees: 0 }
  charIdx = charStep #really starting from second line.

  input.each_with_index do |line, lineIdx|
    #first line is starting point, so there's never a tree
    next if lineIdx == 0 || lineIdx % lineStep != 0

    # puts "L#{lineIdx+1}: #{charIdx} - #{line[charIdx]}"
    result[:trees] += 1 if line[charIdx] == '#'
    charIdx = nextWrappedIndex(charIdx, line, charStep)
  end

  result
end

# -- Outputs --
puts "Problem1: #{problem1(input)}"
puts "Problem2: #{problem2(input)}"
