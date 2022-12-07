module Year2021
  class Day01
    def part1(input)
      input = input.split("\n").map(&:to_i)

      0.upto(input.length - 2).map do |n|
        if input[n+1] > input[n]
          1
        else
          0
        end
      end.reduce(&:+)
    end

    def part2(input)
      input = input.split("\n").map(&:to_i)

      0.upto(input.length - 4).map do |n|
        if input[n+1..n+3].sum > input[n..n+2].sum
          1
        else
          0
        end
      end.reduce(&:+)
    end
  end
end
