module Year2023
  class Day21
    def part1(input)
      inpu2t = "...........
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
          else
            nil
          end
        end
      end.reject(&:nil?)

      rocks = Set.new(rocks)
      maxy = input.length
      maxx = input.first.length

      num_steps = 64
      frontier = { 0 => Set.new([[sy, sx]]) }

      1.upto(num_steps).each do |stepn|
        queue = frontier[stepn - 1].to_a
        visited = Set.new
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

      frontier[num_steps].length
    end

    def part2(input)
      input = "...........
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

      num_steps = 100
      frontier = { 0 => Set.new([[sy, sx]]) }

      1.upto(num_steps).each do |stepn|
        queue = frontier[stepn - 1].to_a
        visited = Set.new
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
            nyy = ny % maxy
            nxx = nx % maxx

            rocks.include?([nyy, nxx])
          end.each do |pair|
            new.add(pair)
          end

        end

        frontier[stepn] = new
      end

      frontier[num_steps].length
    end
  end
end
