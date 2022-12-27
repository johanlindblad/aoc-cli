require 'json'

module Year2022
  class Day13
    def part1(input)

inpu2t = "[1,1,3,1,1]
[1,1,5,1,1]

[[1],[2,3,4]]
[[1],4]

[9]
[[8,7,6]]

[[4,4],4,4]
[[4,4],4,4,4]

[7,7,7,7]
[7,7,7]

[]
[3]

[[[]]]
[[]]

[1,[2,[3,[4,[5,6,7]]]],8,9]
[1,[2,[3,[4,[5,6,0]]]],8,9]"
      input = input.strip.split("\n\n").map do |group|
        a, b = group.split("\n")
        [JSON.parse(a), JSON.parse(b)]
      end

input.map.with_index do |group, index|
        #puts group.first.inspect
        #puts group.last.inspect
        #puts "--"
        [compare(group.first, group.last), 1 + index]
      end.select do |a|
        a.first == 1
      end.map do |a|
        a.last
      end.sum
    end

    def compare(a, b)
      if a.is_a?(Integer) && b.is_a?(Integer)
        return 0 if a == b
        return 1 if a < b
        return -1
      elsif a.is_a?(Array) && b.is_a?(Array)
        c = a.zip(b).map{|pair| compare(*pair)}.reject{|cmp| cmp == 0}.first

        if c.nil?
          if a.length > b.length
            return -1
          elsif a.length < b.length
            return 1
          else
            return 0
          end
        end

        return c
      elsif a.is_a?(Integer)
        compare([a], b)
      elsif b.is_a?(Integer)
        compare(a, [b])
      elsif a.nil?
        1
      elsif b.nil?
        -1
      else
        raise [a, b].inspect
      end
    end

    def part2(input)
      
inpu2t = "[1,1,3,1,1]
[1,1,5,1,1]

[[1],[2,3,4]]
[[1],4]

[9]
[[8,7,6]]

[[4,4],4,4]
[[4,4],4,4,4]

[7,7,7,7]
[7,7,7]

[]
[3]

[[[]]]
[[]]

[1,[2,[3,[4,[5,6,7]]]],8,9]
[1,[2,[3,[4,[5,6,0]]]],8,9]"
      input = input.strip.split("\n\n").flat_map do |group|
        a, b = group.split("\n")
        [JSON.parse(a), JSON.parse(b)]
      end

      input.push([2])
      input.push([6])

      sorted = input.sort { |a, b| -compare(a, b) }

      a = sorted.index([2]) + 1
      b = sorted.index([6]) + 1
      a * b
    end
  end
end
