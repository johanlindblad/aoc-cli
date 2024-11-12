require 'set'

module Year2023
  class Day16
    def part1(input)
      input = input.strip.split("\n").map(&:chars)

      num_lit(input, [[0, -1], [0, 1]])
    end

    def part2(input)
      input = input.strip.split("\n").map(&:chars)

      startsy = 0.upto(input.length - 1).flat_map do |y|
        [[[y, -1], [0, 1]], [[y, input.first.length], [0, -1]]]
      end
      startsx = 0.upto(input.first.length - 1).flat_map do |x|
        [[[-1, x], [1, 0]], [[input.length, x], [-1, 0]]]
      end

      starts = startsx + startsy
      max = 0

      starts.each do |beam|
        lit = num_lit(input, beam)
        max = [max, lit].max
      end

      max
    end

    def num_lit(input, beam)
      beams = [beam]
      lit = Set.new

      until beams.empty?
        beam = beams.shift
        p, d = beam
        y, x = p
        dy, dx = d
        next if lit.include?(beam)
        lit.add(beam) unless x < 0 || y < 0 || x >= input.first.length || y >= input.length

        ny, nx = y+dy, x+dx
        next if ny < 0 || nx < 0 || ny >= input.length || nx >= input.first.length

        case input[ny][nx]
        when "."
          beams.push([[ny, nx], [dy, dx]])
        when "|"
          if dy == 0
            beams.push([[ny, nx], [1, 0]])
            beams.push([[ny, nx], [-1, 0]])
          else
            beams.push([[ny, nx], d])
          end
        when "-"
          if dy == 0
            beams.push([[ny, nx], d])
          else
            beams.push([[ny, nx], [0, 1]])
            beams.push([[ny, nx], [0, -1]])
          end
        when "/"
          new_dir = [-dx, -dy]
          beams.push([[ny, nx], new_dir])
        when "\\"
          new_dir = [dx, dy]
          beams.push([[ny, nx], new_dir])
        end
      end

      lit = lit.to_a.map(&:first).uniq

      return lit.length
    end
  end
end
