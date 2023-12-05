module Year2023
  class Day04
    def part1(input)
      input = input.strip.split("\n")

      cards = input.map do |line|
        num, rest = line.split(": ")
        num = num.split(" ").last.to_i

        winning, own = rest.split(" | ").map { |nums| nums.split(" ").map(&:to_i) }

        [winning, own]
      end

      points = cards.map do |card|
        winning, own = card
        matching = winning & own
        matching.length
      end.reject(&:zero?).map do |num|
        2 ** (num - 1)
      end.sum
    end

    def part2(input)
      input = input.strip.split("\n")

      cards = input.map do |line|
        num, rest = line.split(": ")
        num = num.split(" ").last.to_i

        winning, own = rest.split(" | ").map { |nums| nums.split(" ").map(&:to_i) }

        [winning, own]
      end

      num_copies = Hash[*(0...cards.length).to_a.map { |i| [i, 1] }.flatten]

      cards.each.with_index do |card, index|
        num_copies[index] ||= 1
        winning, own = card
        matching = winning & own
        points = matching.length

        ((index + 1)..(index + points)).each do |i|
          num_copies[i] += num_copies[index]
        end
      end

      num_copies.values.sum
    end
  end
end
