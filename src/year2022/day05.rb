module Year2022
  class Day05
    def part1(input)
      stacks, instructions = input.split("\n\n").map{|s| s.split("\n")}
      letters = stacks[0..-2].reverse

      stackmap = {}

      letters.each do |row|
        row.split("").each.with_index do |l, i|
          if l != " " && l != "[" && l != "]"
            stackmap[i] ||= []
            stackmap[i].push(l)
          end
        end
      end

      stacks = []
      stackmap.keys.sort.each do |key|
        stacks.push(stackmap[key])
      end

      instructions.each do |i|
        i = i.split(" ").map(&:to_i)
        n, f, t = i[1], i[3], i[5]

        temp = stacks[f-1].pop(n)
        stacks[t-1].push(*temp.reverse)
      end

      stacks.map(&:last).join("")
    end

    def part2(input)
      stacks, instructions = input.split("\n\n").map{|s| s.split("\n")}
      letters = stacks[0..-2].reverse

      stackmap = {}

      letters.each do |row|
        row.split("").each.with_index do |l, i|
          if l != " " && l != "[" && l != "]"
            stackmap[i] ||= []
            stackmap[i].push(l)
          end
        end
      end

      stacks = []
      stackmap.keys.sort.each do |key|
        stacks.push(stackmap[key])
      end

      instructions.each do |i|
        i = i.split(" ").map(&:to_i)
        n, f, t = i[1], i[3], i[5]

        temp = stacks[f-1].pop(n)
        stacks[t-1].push(*temp)
      end

      stacks.map(&:last).join("")
    end
  end
end
