module Year2023
  class Day13
    def part1(input)
      patterns = input.strip.split("\n\n").map { _1.split("\n") }

      patterns.map do |pattern|
        vert = 0.upto(pattern.first.length - 2).find do |d|
          reflects_vertical?(pattern, d) == 0
        end

        if vert
          vert + 1
        else
          hori = 0.upto(pattern.length - 1).find do |d|
            reflects_horizontal?(pattern, d) == 0
          end

          100 * (hori + 1)
        end
      end.sum
    end

    def part2(input)
      patterns = input.strip.split("\n\n").map { _1.split("\n") }

      patterns.map do |pattern|
        vert = 0.upto(pattern.first.length - 2).find do |d|
          reflects_vertical?(pattern, d) == 1
        end

        if vert
          vert + 1
        else
          hori = 0.upto(pattern.length - 1).find do |d|
            reflects_horizontal?(pattern, d) == 1
          end

          100 * (hori + 1)
        end
      end.sum
    end

    def reflects_horizontal?(pattern, row)
      under = row + 1
      over = pattern.length - row - 1

      check = [under, over].min

      diff = 0.upto(check - 1).map do |dy|
        count = pattern[row - dy].chars.zip(pattern[row + 1 + dy].chars).count do |pair|
          pair.first != pair.last
        end

        count
      end.sum

      diff
    end

    def reflects_vertical?(pattern, col)
      pattern = pattern.map { _1.split("") }.transpose.map { _1.join("") }
      left = col + 1
      right = pattern.length - col - 1

      check = [left, right].min

      diff = 0.upto(check - 1).map do |dx|
        count = pattern[col - dx].chars.zip(pattern[col + 1 + dx].chars).count do |pair|
          pair.first != pair.last
        end

        count
      end.sum

      diff
    end
  end
end
