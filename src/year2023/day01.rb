module Year2023
  class Day01
    def part1(input)
      input = input.split("\n")

      input.map do |line|
        numbers = line.split("").map(&:to_i).reject(&:zero?)

        "#{numbers.first}#{numbers.last}"
      end.map(&:to_i).sum
    end

    def part2(input)
      input = input.split("\n")

      input.map do |line|
        line = line.gsub('one', 'one1one')
          .gsub('two', 'two2two')
          .gsub('three', 'three3three')
          .gsub('four', 'four4four')
          .gsub('five', 'five5five')
          .gsub('six', 'six6six')
          .gsub('seven', 'seven7seven')
          .gsub('eight', 'eight8eight')
          .gsub('nine', 'nine9nine')

        numbers = line.split("").map(&:to_i).reject(&:zero?)

        "#{numbers.first}#{numbers.last}"
      end.map(&:to_i).sum
    end
  end
end
