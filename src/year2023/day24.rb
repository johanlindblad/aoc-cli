require 'matrix'

module Year2023
  class Day24
    def part1(input)
      area = 200_000_000_000_000..400_000_000_000_000

      sample = false

      if sample
        input = "19, 13, 30 @ -2,  1, -2
18, 19, 22 @ -1, -1, -2
20, 25, 34 @ -2, -2, -4
12, 31, 28 @ -1, -2, -1
20, 19, 15 @  1, -5, -3"
        area = 7..27
      end

      hailstones = input.split("\n").map do |line|
        ints = line.split(/,|@/).map(&:to_i)
        [ints[0..2], ints[3..]]

        a = Point.new(ints[0], ints[1])
        b = Point.new(ints[0] + ints[3], ints[1] + ints[4])

        line = Line.new(a, b)
        line
      end

      num = hailstones.combination(2).count do |pair|
        a, b = pair

        intersection = a.intersect(b)

        if !intersection.nil?
          px = intersection.x
          py = intersection.y
          a_future = a.x_slope >= 0 ? px > a.x_orig : px < a.x_orig
          b_future = b.x_slope >= 0 ? px > b.x_orig : px < b.x_orig

          inside = area.include?(px) && area.include?(py)

          a_future && b_future && inside
        else
          false
        end
      end

      num
    end

    def part2(input)
      # https://www.reddit.com/r/adventofcode/comments/18pnycy/2023_day_24_solutions/khlrstp/
      _input = "19, 13, 30 @ -2,  1, -2
18, 19, 22 @ -1, -1, -2
20, 25, 34 @ -2, -2, -4
12, 31, 28 @ -1, -2, -1
20, 19, 15 @  1, -5, -3"

      rays = input.split("\n").map do |line|
        line.split(/,|@/).map(&:to_i)
      end

      a = []
      b = []

      1.upto(3) do |n|
        # rubocop:disable Naming/VariableName
        px0, py0, pz0, vx0, vy0, vz0 = rays[0]
        pxN, pyN, pzN, vxN, vyN, vzN = rays[n]
        a.push([vy0 - vyN, vxN - vx0, 0, pyN - py0, px0 - pxN, 0])
        b.push(px0 * vy0 - py0 * vx0 - pxN * vyN + pyN * vxN)
        a.push([vz0 - vzN, 0, vxN - vx0, pzN - pz0, 0, px0 - pxN])
        b.push(px0 * vz0 - pz0 * vx0 - pxN * vzN + pzN * vxN)
        # rubocop:enable Naming/VariableName
      end

      a = Matrix[*a]

      solution = cramers_rule(a, b)
      solution.first(3).sum
    end

    def cramers_rule(a, terms)
      raise ArgumentError, " Matrix not square" unless a.square?

      cols = a.to_a.transpose
      cols.each_index.map do |i|
        c = cols.dup
        c[i] = terms
        Matrix.columns(c).det / a.det
      end
    end
  end

  Point = Struct.new(:x, :y)

  class Line
    attr_reader :a, :b, :x_orig, :x_slope

    def initialize(point1, point2)
      @x_orig = point1.x
      @x_slope = point2.x - point1.x
      @a = (point1.y - point2.y).fdiv(point1.x - point2.x)
      @b = point1.y - @a * point1.x
    end

    def intersect(other)
      return nil if @a == other.a

      x = (other.b - @b).fdiv(@a - other.a)
      y = @a * x + @b
      Point.new(x, y)
    end

    def to_s
      "y = #{@a}x #{@b.positive? ? '+' : '-'} #{@b.abs}"
    end
  end
end
