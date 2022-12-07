module Year2022
  class Day01
    def part1(input)
      elves = input.split("\n\n")

      elves.map do |elf|
        elf.split("\n").map(&:to_i).sum
      end.max
    end

    def part2(input)
      elves = input.split("\n\n")

      elves.map do |elf|
        elf.split("\n").map(&:to_i).sum
      end.sort.reverse[0..2].sum
    end
  end
end
