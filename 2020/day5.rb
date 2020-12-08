# Day5
#input = File.open('day5_input_eg.txt').readlines.map(&:chomp)
input = File.open('day5_input.txt').readlines.map(&:chomp)

require "ostruct"

def node(lower, upper)
  OpenStruct.new(
    {
      lower: lower,
      upper: upper,
      left: nil,
      right: nil
    })
end

def btree(lower, upper, root=nil)
  root = node(lower, upper) unless root

  split = lower + ((upper - lower) / 2)
  root.left = node(lower, split)
  root.right = node(split+1, upper)

  btree(lower, split, root.left) unless root.left.lower == root.left.upper
  btree(split+1, upper, root.right) unless root.right.lower == root.right.upper
  root
end


def problem1(input)
  result = { row_seats: [], seat_ids: [] }

  rows = btree(0, 127)
  seats = btree(0,7)

  input.each do |line|
    # puts line

    # row chars
    selected_row = rows
    line[0...7].split('').each do |char|
      selected_row = char == 'F' ? selected_row.left : selected_row.right
      # puts "    Row: #{selected_row.lower} : #{selected_row.upper}"
    end

    #seat chars
    selected_seat = seats
    line[7..-1].split('').each do |char|
      selected_seat = char == 'L' ? selected_seat.left : selected_seat.right
      # puts "    Seat: #{selected_seat.lower} : #{selected_seat.upper}"
    end

    result[:row_seats].push([selected_row.lower, selected_seat.lower])
    result[:seat_ids].push((selected_row.lower * 8) + selected_seat.lower)
  end

  result[:max_seat_id] = result[:seat_ids].max
  result[:max_seat_id]
end


def problem2(input)
  result = { row_seats: {}, seat_ids: [] }
  rows = btree(0, 127)
  seats = btree(0,7)

  input.each do |line|
    # puts line

    # row chars
    selected_row = rows
    line[0...7].split('').each do |char|
      selected_row = char == 'F' ? selected_row.left : selected_row.right
      # puts "    Row: #{selected_row.lower} : #{selected_row.upper}"
    end

    #seat chars
    selected_seat = seats
    line[7..-1].split('').each do |char|
      selected_seat = char == 'L' ? selected_seat.left : selected_seat.right
      # puts "    Seat: #{selected_seat.lower} : #{selected_seat.upper}"
    end

    result[:row_seats][selected_row.lower] = [] unless result[:row_seats][selected_row.lower]
    result[:row_seats][selected_row.lower].push(selected_seat.lower)
    result[:seat_ids].push((selected_row.lower * 8) + selected_seat.lower)
  end

  missing = {}
  (0..127).to_a.each do |row|
    (0..7).to_a.each do |seat|
      missing[row] = Array(missing[row]).push(seat) unless result[:row_seats][row]&.include?(seat)
    end
  end
  # puts missing

  my_possible_rows = missing.select { |row| missing[row].size != 8 }
  my_possible_seat_ids = my_possible_rows.each_with_object([]) do |(row, seats), memo|
    seats.each { |seat| memo.push((row * 8) + seat)}
  end

  my_possible_seat_ids.filter do |seat_id|
    result[:seat_ids].include?(seat_id + 1) &&
      result[:seat_ids].include?(seat_id - 1)
  end
end

# -- Outputs --
puts "Problem1: #{problem1(input)}"
puts "Problem2: #{problem2(input)}"
