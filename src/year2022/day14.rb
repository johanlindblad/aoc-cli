module Year2022
  class Day14
    def part1(input)
      in2put = "498,4 -> 498,6 -> 496,6
503,4 -> 502,4 -> 502,9 -> 494,9"
      input = input.strip.split("\n")

      map = {}

      input.each do |line|
        parts = line.split(' -> ').map do |part|
          part.split(',').map(&:to_i)
        end

        1.upto(parts.length - 1).each do |to_i|
          from_i = to_i - 1

          from = parts[from_i]
          to = parts[to_i]

          if from.first == to.first
            x = from.first

            s, e = [from.last, to.last].sort

            (s..e).each do |y|
              map[[y, x]] = '#'
            end
          else
            y = from.last

            s, e = [from.first, to.first].sort

            (s..e).each do |x|
              map[[y, x]] = '#'
            end
          end
        end
      end

      void = map.keys.max_by do |key|
        key.first
      end.first

      num_sand = 0

      loop do
        y, x = [0, 500]

        loop do
          if y == void
            return num_sand
          elsif !map.has_key?([y + 1, x])
            y += 1
          elsif !map.has_key?([y + 1, x - 1])
            y += 1
            x -= 1
          elsif !map.has_key?([y + 1, x + 1])
            y += 1
            x += 1
          else
            break
          end
        end

        map[[y, x]] = 'o'
        num_sand += 1
        puts num_sand
      end
    end

    def part2(input)
      inp2ut = "498,4 -> 498,6 -> 496,6
503,4 -> 502,4 -> 502,9 -> 494,9"
      input = input.strip.split("\n")

      map = {}

      input.each do |line|
        parts = line.split(' -> ').map do |part|
          part.split(',').map(&:to_i)
        end

        1.upto(parts.length - 1).each do |to_i|
          from_i = to_i - 1

          from = parts[from_i]
          to = parts[to_i]

          if from.first == to.first
            x = from.first

            s, e = [from.last, to.last].sort

            (s..e).each do |y|
              map[[y, x]] = '#'
            end
          else
            y = from.last

            s, e = [from.first, to.first].sort

            (s..e).each do |x|
              map[[y, x]] = '#'
            end
          end
        end
      end

      floor = map.keys.max_by do |key|
        key.first
      end.first + 2

      num_sand = 0

      loop do
        y, x = [0, 500]

        loop do
          if !map.has_key?([y + 1, x]) && (y + 1) != floor
            y += 1
          elsif !map.has_key?([y + 1, x - 1]) && (y + 1) != floor
            y += 1
            x -= 1
          elsif !map.has_key?([y + 1, x + 1]) && (y + 1) != floor
            y += 1
            x += 1
          else
            break
          end
        end

        map[[y, x]] = 'o'
        num_sand += 1

        if y == 0
          return num_sand
        end
      end
    end
  end
end
