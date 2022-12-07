module Year2022
  class Day06
    def part1(input)
      input = input.strip
      4 + 0.upto(input.length - 4).select do |i|
        input[i..i+3].split("").sort.uniq.length == 4
      end.first
    end

    def part2(input)
      input = input.strip
      14 + 0.upto(input.length - 14).select do |i|
        input[i..i+13].split("").sort.uniq.length == 14
      end.first
    end
  end
end
