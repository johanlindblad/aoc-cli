module Year2022
  class Day18
    def part1(input)
      input = input.strip.split("\n").map do |row|
        row.split(',').map(&:to_i)
      end

      input.map do |cube|
        6 - input.count do |other_cube|
          touch?(cube, other_cube)
        end
      end.reduce(&:+)
    end

    def touch?(cube1, cube2)
      x1, y1, z1 = cube1
      x2, y2, z2 = cube2

      [
        (x1 - x2).abs,
        (y1 - y2).abs,
        (z1 - z2).abs
      ].sort == [0, 0, 1]
    end

    def part2(input)
      original_input = input

      input = input.strip.split("\n").map do |row|
        row.split(',').map(&:to_i)
      end

      cubes = Set.new(input)

      bounds = [0, 1, 2].map { |i| input.map { |cube| cube[i] }.minmax }.map do |ra|
        Range.new(ra.first - 1, ra.last + 1)
      end

      air = Set.new
      external_air = Set.new

      bounds[0].each do |x|
        bounds[1].each do |y|
          bounds[2].each do |z|
            air.add([x, y, z]) if !cubes.member?([x, y, z])
          end
        end
      end

      start = [0, 0, 0]
      raise 'Touches' if input.any? { |cube| touch?(cube, start) }

      queue = [start]

      deltas = [
        [-1, 0, 0],
        [1, 0, 0],
        [0, -1, 0],
        [0, 1, 0],
        [0, 0, -1],
        [0, 0, 1]
      ]

      visited = {}

      until queue.empty?
        x, y, z = queue.shift

        neighbours = deltas.map do |delta|
          delta.zip([x, y, z]).map(&:sum)
        end

        neighbours.filter! do |neighbour|
          in_range = neighbour.to_enum.with_index.all? do |coord, index|
            bounds[index].include?(coord) || coord == 0
          end
          is_cube = cubes.include?(neighbour)
          v = visited.key?(neighbour)

          in_range && !is_cube && !v
        end

        neighbours.each do |neighbour|
          queue.push(neighbour)
          visited[neighbour] = true
          air.delete(neighbour)
          external_air.add(neighbour)
        end
      end

      internal = part1(air.to_a.map do |coord|
        coord.map(&:to_s).join(',')
      end.join("\n"))

      external = part1(original_input)

      external - internal
    end
  end
end
