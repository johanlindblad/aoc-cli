module Year2022
  class Day11
    def part1(input)
      input = input.strip.split("\n\n")

      monkeys = input.map do |group|
        group = group.split("\n")
        items = group[1].split(": ").last.split(", ").map(&:to_i)
        operation = group[2].split(": ").last
        test = group[3].split("divisible by").last.to_i
        if_true = group[4].split(" ").last.to_i
        if_false = group[5].split(" ").last.to_i

        [items, operation, test, if_true, if_false]
      end

      puts monkeys.first.inspect

      inspections = monkeys.map { 0 }

      20.times do |round|
        monkeys.each.with_index do |monkey, index|
          until monkey.first.empty? do
            inspections[index] += 1
            inspects = monkey.first.shift

            old = inspects
            new = nil
            eval(monkey[1])

            new /= 3
            new = new.to_i

            test = monkey[2]

            if new % test == 0
              monkeys[monkey[3]][0].push(new)
            else
              monkeys[monkey[4]][0].push(new)
            end
          end
        end
      end

      inspections.max(2).reduce(&:*)
    end

    def part2(input)
      input = input.strip.split("\n\n")

      monkeys = input.map do |group|
        group = group.split("\n")
        items = group[1].split(": ").last.split(", ").map(&:to_i)
        operation = group[2].split(": ").last
        test = group[3].split("divisible by").last.to_i
        if_true = group[4].split(" ").last.to_i
        if_false = group[5].split(" ").last.to_i

        [items, operation, test, if_true, if_false]
      end

      inspections = [0] * monkeys.length
      tests = monkeys.map { |m| m[2] }.reduce(&:*)

      10_000.times do
        monkeys.each.with_index do |monkey, index|
          until monkey.first.empty? do
            inspections[index] += 1
            old = monkey.first.shift

            new = nil
            eval(monkey[1])

            new = new % tests

            test = monkey[2]

            if (new % test) == 0
              monkeys[monkey[3]][0].push(new)
            else
              monkeys[monkey[4]][0].push(new)
            end
          end
        end
      end

      inspections.max(2).reduce(&:*)
    end
  end
end
