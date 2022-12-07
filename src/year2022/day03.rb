module Year2022
  class Day03
    def part1(input)
      input = input.split("\n")

      ps = ('a'..'z').to_a.join("") + ('A'..'Z').to_a.join("")

      input.map do |line|
        a, b = line.chars.each_slice(line.size / 2).to_a

        common = (a & b)
        ps.index(common.first) + 1
      end.sum
    end

    def part2(input)
      input = input.split("\n")
      ps = ('a'..'z').to_a.join("") + ('A'..'Z').to_a.join("")

      input.each_slice(3).map do |slice|
        l = slice.map(&:chars).reduce(:&)
        ps.index(l.first) + 1
      end.sum
    end
  end
end
