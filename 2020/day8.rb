# Day8
#input = File.open('day8_input_eg.txt').readlines.map(&:chomp)
input = File.open('day8_input.txt').readlines.map(&:chomp)

require 'ostruct'

def parse_instructions(input)
  input.map do |line|
    if line=~ /^(\w{3}) (.*)/
      instruction($1.strip, $2.chomp.strip)
    end
  end
end

def instruction(cmd, value)
  OpenStruct.new(
    {
      cmd: cmd,
      value: value,
      executed: false
    })
end

def execute_instruction(instruction, accumulator, currentIdx)
  case instruction.cmd
  when 'nop'
    [accumulator, currentIdx+1]
  when 'acc'
    sign = instruction.value[0]
    numeral = instruction.value[1..-1].to_i
    sign == '-' ? [accumulator-numeral, currentIdx+1] : [accumulator+numeral, currentIdx+1]
  when 'jmp'
    sign = instruction.value[0]
    numeral = instruction.value[1..-1].to_i
    sign == '-' ? [accumulator, currentIdx-numeral] : [accumulator, currentIdx+numeral]
  end
end

def problem1(input)
  instructions = parse_instructions(input)

  currentIdx = 0
  currentInstruction = instructions.first
  accumulator = 0

  while !currentInstruction.executed
    accumulator, currentIdx = execute_instruction(instructions[currentIdx], accumulator, currentIdx)
    currentInstruction.executed = true
    currentInstruction = instructions[currentIdx]
  end

  accumulator
end

# slightly different from problem1, return value indicates if last instruction was run
# takes instructions instead of input as param
def execute_instruction_set(instructions)
  currentIdx = 0
  currentInstruction = instructions.first
  accumulator = 0

  while currentInstruction && !currentInstruction.executed
    accumulator, currentIdx = execute_instruction(instructions[currentIdx], accumulator, currentIdx)
    currentInstruction.executed = true
    currentInstruction = instructions[currentIdx]
  end

  [instructions.last.executed, accumulator]
end

def nop_jmp_swaps(instructions)
  instructions.each_with_index do |instruction, idx|
    if instruction.cmd == 'nop'
      new_instructions = instructions.map(&:dup)
      new_instructions[idx].cmd = 'jmp'

      successfully_run, accumulator = execute_instruction_set(new_instructions)
      return accumulator if successfully_run
    end

    if instruction.cmd == 'jmp'
      new_instructions = instructions.map(&:dup)
      new_instructions[idx].cmd = 'nop'

      successfully_run, accumulator = execute_instruction_set(new_instructions)
      return accumulator if successfully_run
    end
  end
  fail "None of the instruction sets ran successfully!!"
end

def problem2(input)
  instructions = parse_instructions(input)
  nop_jmp_swaps(instructions)
end

# -- Outputs --
puts "Problem1: #{problem1(input)}"
puts "Problem2: #{problem2(input)}"
