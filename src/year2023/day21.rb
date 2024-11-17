module Year2023
  class Day21
    def part1(input)
      _input = "...........
.....###.#.
.###.##..#.
..#.#...#..
....#.#....
.##..S####.
.##..#...#.
.......##..
.##.#.####.
.##..##.##.
..........."
      input = input.strip.split("\n").map(&:chars)

      rocks, sx, sy, maxx, maxy = parse_input(input)

      frontier = min_steps(rocks, sx, sy, maxx, maxy, 64)

      frontier[64].length
    end

    # https://github.com/villuna/aoc23/wiki/A-Geometric-solution-to-advent-of-code-2023,-day-21
    def part2(input)
      input = input.strip.split("\n").map(&:chars)

      rocks, sx, sy, maxx, maxy = parse_input(input)

      frontier = min_steps(rocks, sx, sy, maxx, maxy, maxx + maxy)
      num_steps = frontier.flat_map do |key, set|
        set.map { |pair| [pair, key - 2] }
      end.to_h

      even_corners = num_steps.values.select(&:even?).select { |n| n > 65 }.count
      odd_corners = num_steps.values.select(&:odd?).select { |n| n > 65 }.count
      even_full = num_steps.values.select(&:even?).count
      odd_full = num_steps.values.select(&:odd?).count

      n = 202_300

      odd = (n + 1).pow(2)
      even = n.pow(2)

      (odd * odd_full) + (even * even_full) - ((n + 1) * odd_corners) + (n * even_corners)
    end

    def min_steps(rocks, sx, sy, maxx, maxy, num_steps = 64)
      frontier = { 0 => Set.new([[sy, sx]]) }
      visited = Set.new

      1.upto(num_steps).each do |stepn|
        queue = frontier[stepn - 1].to_a
        new = Set.new

        until queue.empty?
          y, x = queue.shift
          next if visited.include?([y, x])

          visited.add([y, x])

          [[0, 1], [0, -1], [1, 0], [-1, 0]].map do |pair|
            dy, dx = pair
            ny = y + dy
            nx = x + dx
            [ny, nx]
          end.reject do |pair|
            ny, nx = pair
            nx < 0 || ny < 0 || nx >= maxx || ny >= maxy || rocks.include?([ny, nx])
          end.each do |pair|
            new.add(pair)
          end

        end

        frontier[stepn] = new
      end

      frontier.reject { |_key, value| value.empty? }
    end

    def parse_input(input)
      sy = nil
      sx = nil

      rocks = input.flat_map.with_index do |row, y|
        row.map.with_index do |char, x|
          if char == "#"
            [y, x]
          elsif char == "S"
            sy = y
            sx = x
            nil
          end
        end
      end.reject(&:nil?)

      rocks = Set.new(rocks)
      maxy = input.length
      maxx = input.first.length

      [rocks, sx, sy, maxx, maxy]
    end
  end
end
