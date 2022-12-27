module Year2021
  class Day25
    def part1(input)
      inpu2t = "v...>>.vv>
.vv>>.vv..
>>.>v>...v
>>v>>.>.v.
v>v.vv.v..
>.>>..v...
.vv..>.>v.
v.v..>>v.v
....v..v.>"

      input = input.strip.split("\n").map(&:chars)
      height = input.length
      width = input.first.length

      cucumbers = {}
      #south = {}

      input.each.with_index do |row, y|
        row.each.with_index do |char, x|
          if char == 'v'
            cucumbers[[y, x]] = :south
          elsif char == '>'
            cucumbers[[y, x]] = :east
          end
        end
      end

      (0..).each do |step|
        new_cucumbers = {}

        # puts cucumbers.keys.inspect
        cucumbers.each do |coord, direction|
          next if direction == :south

          y, x = coord
          nx = (x + 1) % width
          nx = x if cucumbers.key?([y, nx])

          # puts "from #{x} to #{nx}"

          new_cucumbers[[y, nx]] = :east
        end

        cucumbers.each do |coord, direction|
          next if direction == :east

          y, x = coord
          ny = (y + 1) % height
          ny = y if new_cucumbers.key?([ny, x])
          ny = y if cucumbers[[ny, x]] == :south

          # puts "from #{y} to #{ny}"

          new_cucumbers[[ny, x]] = :south
        end

        return step + 1 if cucumbers == new_cucumbers
        cucumbers = new_cucumbers
      end
    end

    def part2(input)
      nil
    end
  end
end
