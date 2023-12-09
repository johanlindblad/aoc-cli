module Year2023
  class Day09
    def part1(input)
      input
        .split("\n")
        .map { |line| line.split(" ").map(&:to_i) }
        .map { |seq| predicted_next(seq) }
        .sum
    end

    def part2(input)
      input
        .split("\n")
        .map { |line| line.split(" ").map(&:to_i).reverse }
        .map { |seq| predicted_next(seq) }
        .sum
    end

    def predicted_next(seq, acc=nil)
      acc ||= seq.last
      diffs = seq[1..].zip(seq)[0..-1].map { |ab| ab.first - ab.last }

      if diffs.all?(&:zero?)
        acc
      else
        predicted_next(diffs, diffs.last + acc)
      end
    end
  end
end
