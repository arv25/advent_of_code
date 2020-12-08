# Day4
#input = File.open('day4_input_eg.txt').readlines
input = File.open('day4_input.txt').readlines

def readPassports(input)
  passports = {}
  currentIdx = 0
  input.each do |line|
    if line != "\n"
      key_values_pairs = line.split(' ')
      key_values = key_values_pairs.map do |kv|
        kv.split(':')
      end

      passports[currentIdx] = {} unless passports[currentIdx]

      key_values.each do |(key, value)|
        passports[currentIdx][key.to_sym] = value
      end

    else
      currentIdx += 1
    end

  end

  passports.values
end

def requiredKeysPresent?(passport, required=%i(byr iyr eyr hgt hcl ecl pid))
  required.all? { |r| passport.key? r }
end

def keyDataValid?(passport,
                  validations={
                    byr: lambda { |val| val.to_i.between?(1920, 2002) },
                    iyr: lambda { |val| val.to_i.between?(2010, 2020) },
                    eyr: lambda { |val| val.to_i.between?(2020, 2030) },
                    hgt: lambda do |val|
                      if val =~ /^(\d+)(\w+)/
                        return $1.to_i.between?(150, 193) if $2 == 'cm'
                        return $1.to_i.between?(59, 76) if $2 == 'in'
                      end
                      false
                    end,
                    hcl: lambda { |val| val =~ /^#[\w\d]{6}$/ },
                    ecl: lambda { |val| %i(amb blu brn gry grn hzl oth).include?(val.to_sym) },
                    pid: lambda { |val| val =~ /^[\d]{9}$/ }
                  })

  validations.all? do |(key, val_fn)|
    val_fn.call(passport[key])
  end
end



def problem1(input)
  result = { valid_count: 0 }
  passports = readPassports(input)

  passports.each do |passport|
    result[:valid_count] += 1 if requiredKeysPresent?(passport)
  end
  result
end


def problem2(input)
  result = { valid_count: 0 }
  passports = readPassports(input)

  passports.each do |passport|
    result[:valid_count] += 1 if requiredKeysPresent?(passport) && keyDataValid?(passport)
  end

  result
end

# -- Outputs --
puts "Problem1: #{problem1(input)}"
puts "Problem2: #{problem2(input)}"
