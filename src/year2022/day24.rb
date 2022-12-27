module Year2022
  class Day24
    def part1(input)
      return 'skip'
      input = "#.######
#>>.<^<#
#.<..<<#
#>v.><>#
#<^v^^>#
######.#"

      input = input.strip.split("\n").map(&:chars)

      start = [0, 1]
      goal = [input.length - 1, input.first.length - 2]

      max_y = input.length - 2
      max_x = input.first.length - 2

      blizzards = []

      0.upto(input.length - 1).each do |y|
        0.upto(input.first.length - 1).each do |x|
          blizzards.push([[y, x], [0, 1]]) if input[y][x] == '>'
          blizzards.push([[y, x], [0, -1]]) if input[y][x] == '<'
          blizzards.push([[y, x], [1, 0]]) if input[y][x] == 'v'
          blizzards.push([[y, x], [-1, 0]]) if input[y][x] == '^'
        end
      end

      blizzards_after = {}
      blizzards_after[0] = blizzards

      possible = Set.new([start])

      0.upto(500).each do |minute|
        new_possible = Set.new

        blizzards = blizzards.map do |blizzard|
          y, x = blizzard.first
          dy, dx = blizzard.last

          y += dy
          x += dx

          y = 1 if y > max_y
          y = max_y if y < 1
          x = 1 if x > max_x
          x = max_x if x < 1

          [[y, x], [dy, dx]]
        end

        impossible = Set.new(blizzards.map(&:first))

        possible.each do |pos|
          deltas = [[0, 0], [1, 0], [-1, 0], [0, 1], [0, -1]]

          deltas.each do |delta|
            dy, dx = delta
            y, x = pos

            ny = y + dy
            nx = x + dx

            can_move = ny > 0 && ny <= max_y && nx > 0 && nx <= max_x
            can_move = false if impossible.include?([ny, nx])
            can_move = true if goal == [ny, nx]

            next unless can_move

            new_possible.add([ny, nx])
            return minute + 1 if goal == [ny, nx]
          end
        end

        possible = new_possible
      end
    end

    def part2(input)
      input = input.strip.split("\n").map(&:chars)

      start = [0, 1]
      goal = [input.length - 1, input.first.length - 2]

      max_y = input.length - 2
      max_x = input.first.length - 2

      blizzards = []

      0.upto(input.length - 1).each do |y|
        0.upto(input.first.length - 1).each do |x|
          blizzards.push([[y, x], [0, 1]]) if input[y][x] == '>'
          blizzards.push([[y, x], [0, -1]]) if input[y][x] == '<'
          blizzards.push([[y, x], [1, 0]]) if input[y][x] == 'v'
          blizzards.push([[y, x], [-1, 0]]) if input[y][x] == '^'
        end
      end

      step = 0

      possible = Set.new([start])

      0.upto(5000).each do |minute|
        new_possible = Set.new

        blizzards = blizzards.map do |blizzard|
          y, x = blizzard.first
          dy, dx = blizzard.last

          y += dy
          x += dx

          y = 1 if y > max_y
          y = max_y if y < 1
          x = 1 if x > max_x
          x = max_x if x < 1

          [[y, x], [dy, dx]]
        end

        impossible = Set.new(blizzards.map(&:first))

        possible.each do |pos|
          deltas = [[0, 0], [1, 0], [-1, 0], [0, 1], [0, -1]]

          deltas.each do |delta|
            dy, dx = delta
            y, x = pos

            ny = y + dy
            nx = x + dx

            can_move = ny > 0 && ny <= max_y && nx > 0 && nx <= max_x
            can_move = false if impossible.include?([ny, nx])
            can_move = true if goal == [ny, nx]
            can_move = true if start == [ny, nx]

            next unless can_move

            new_possible.add([ny, nx])
          end
        end

        possible = new_possible

        if step == 0
          if new_possible.include?(goal)
            step += 1
            possible = [goal]
            puts "first done after #{minute}"
          end
        elsif step == 1
          if new_possible.include?(start)
            step += 1
            possible = [start]
            puts "second done after #{minute}"
          end
        elsif step == 2
          if new_possible.include?(goal)
            puts "third done after #{minute}"
            return minute + 1
          end
        end
      end
    end
  end
end
