module Year2023
  class Day11
    def part1(input)
      inner(input)
    end

    def part2(input)
      inner(input, 1_000_000 - 1)
    end

    def inner(input, extra=1)
      input = input.strip.split("\n").map(&:chars)
      maxy = input.length - 1
      maxx = input.first.length - 1

      empty_rows = (0..maxy).select do |y|
        input[y].uniq.length == 1
      end
      empty_cols = (0..maxx).select do |x|
        input.transpose[x].uniq.length == 1
      end

      galaxies = (0..maxy).to_a.product((0..maxx).to_a).select do |pair|
        y, x = pair
        input[y][x] == "#"
      end.map do |pair|
        y, x = pair
        empty_y_before = empty_rows.select { _1 < y }.count * extra
        empty_x_before = empty_cols.select { _1 < x }.count * extra

        [y + empty_y_before, x + empty_x_before]
      end

      pairs = galaxies.combination(2).map do |gs|
        a, b = gs
        y1, x1 = a
        y2, x2 = b

        (y1 - y2).abs + (x1 - x2).abs
      end

      pairs.sum
    end
  end
end
