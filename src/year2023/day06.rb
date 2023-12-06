module Year2023
  class Day06
    def part1(input)
      input = input.strip.split("\n")

      races = input.map { |line| line.split(": ").last.split(" ").map(&:to_i) }.transpose

      races.map do |race|
        time, record = race

        options = (0..time).map do |speed|
          (time - speed) * speed
        end

        options.count do |distance|
          distance > record
        end
      end.reduce(&:*)
    end

    def part2(input)
      input = input.strip.split("\n")
      race = input.map { |line| line.split(": ").last.split(" ").join.to_i }

      time, record = race

      options = (0..time).map do |speed|
        (time - speed) * speed
      end

      first = options.find_index { |d| d > record }
      last = options.length - first

      # Symmetry
      last - first
    end
  end
end
