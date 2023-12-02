module Year2023
  class Day02
    def part1(input)
      input = input.split("\n")

      games = input
        .map(&self.method(:parse_line))

      games.select do |num_and_max|
        _num, max = num_and_max
        max["green"] <= 13 && max["red"] <= 12 && max["blue"] <= 14
      end.map(&:first).sum
    end

    def part2(input)
      input = input.split("\n")

      games = input
        .map(&self.method(:parse_line))
        .map(&:last)

      games.map do |max|
        max.values.reduce(&:*)
      end.sum
    end

    def parse_line(line)
      number = line.split(" ")[1].to_i

      max = line
        .split(": ")
        .last
        .split("; ")
        .reduce({}, &self.method(:max_colors))

      [number, max]
    end

    def max_colors(max, trial)
      trial.split(", ").each do |pair|
        count, color = pair.split(" ")
        count = count.to_i

        max[color] ||= count
        max[color] = count if count > max[color]
      end

      max
    end
  end
end
