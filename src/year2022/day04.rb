module Year2022
  class Day04
    def part1(input)
      input = input.split("\n")

      input.map do |line|
        ps = line.split(",").map do |pair|
          pair.split("-").map(&:to_i)
        end

        rs = ps.map{|p| Range.new(*p)}

        rs.first.cover?(rs.last) || rs.last.cover?(rs.first)
      end.select{|p| p == true}.count
    end

    def part2(input)
      input = input.split("\n")

      input.map do |line|
        ps = line.split(",").map do |pair|
          pair.split("-").map(&:to_i)
        end

        rs = ps.map{|p| Range.new(*p)}

        overlap?(rs.first, rs.last)
      end.select{|p| p == true}.count
    end

    def overlap?(r1,r2)
  !(r1.first > r2.last || r1.last < r2.first)
    end
  end
end
