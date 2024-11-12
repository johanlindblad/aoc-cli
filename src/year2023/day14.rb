require 'set'

module Year2023
  class Day14
    def part1(input)
inp2ut = "O....#....
O.OO#....#
.....##...
OO.#O....O
.O.....O#.
O.#..O.#.#
..O..#O..O
.......O..
#....###..
#OO..#...."
      
      input = input.strip.split("\n").map(&:chars)

      obstacles = Set.new
      rocks = []

      input.each.with_index do |row, y|
        row.each.with_index do |col, x|
          if col == "#"
            obstacles.add([y, x])
          elsif col == "O"
            rocks.push([y, x])
          end
        end
      end

      tilted = []
      rocks.each do |rock|
        y, x = rock

        loop do
          if !obstacles.include?([y - 1, x]) && !tilted.include?([y - 1, x]) && y > 0
            y = y - 1
          else
            break
          end
        end

        tilted.push([y, x])
      end

      height = input.length

      load = tilted.map do |rock|
        y, x = rock

        height - y
      end.sum
    end

    def part2(input)
      input = input.strip.split("\n").map(&:chars)

      obstacles = Set.new
      rocks = Set.new

      input.each.with_index do |row, y|
        row.each.with_index do |col, x|
          if col == "#"
            obstacles.add([y, x])
          elsif col == "O"
            rocks.add([y, x])
          end
        end
      end

      directions = [[-1, 0], [0, -1], [1, 0], [0, 1]]
      height = input.length
      width = input.first.length
      after = {rocks => 0}
      goal = 1_000_000_000

      1.upto(goal).each do |i|
        directions.each do |dir|
          tilted = Set.new
          dy, dx = dir

          sorted = rocks.to_a.sort_by do |r|
            y, x = r
            ((y * dy) + (x * dx)) * -1
          end

          sorted.each do |rock|
            y, x = rock

            loop do
              ny = y + dy
              nx = x + dx
              if !obstacles.include?([ny, nx]) && !tilted.include?([ny, nx]) && ny >= 0 && ny < height && nx >= 0 && nx < width
                y = ny
                x = nx
              else
                break
              end
            end

            tilted.add([y, x])
          end

          rocks = tilted
        end

        if after.has_key?(rocks)
          diff = i - after[rocks]
          remaining = goal - i
          if (remaining % diff) == 0
            return rocks.map do |rock|
              y, x = rock
              height - y
            end.sum
          end
        end

        after[rocks] = i
      end
    end
  end
end
