module Year2023
  class Day08
    def part1(input)
      path, network = input.strip.split("\n\n")
      path = path.split("")

      network = network.split("\n").map do |line|
        name, rest = line.split(" = ")
        rest = rest.gsub("(", "").gsub(")", "")
        rest = rest.split(", ")

        [name, rest]
      end.to_h

      i = 0
      at = "AAA"

      loop do
        p = path[i % path.length]
        if at === "ZZZ"
          return i
        end

        if p == "L"
          at = network[at].first
        else
          at = network[at].last
        end

        i += 1

      end
    end

    def part2(input)
      path, network = input.strip.split("\n\n")
      path = path.split("")

      network = network.split("\n").map do |line|
        name, rest = line.split(" = ")
        rest = rest.gsub("(", "").gsub(")", "")
        rest = rest.split(", ")

        [name, rest]
      end.to_h

      i = 0
      at = "AAA"
      at = network.keys.select do |key|
        key.split("").last == "A"
      end
      periods = {}
      num = at.length

      loop do
        p = path[i % path.length]
        done = at.map do |a|
          a.split("").last == "Z"
        end

        if done.any?
          done.each.with_index do |d, j|
            periods[j] = i if d == true && !periods.has_key?(j)
          end
        end

        if periods.keys.length == num
          break
        end

        if p == "L"
          at = at.map { |a| network[a].first }
        else
          at = at.map { |a| network[a].last }
        end

        i += 1
      end
      periods.values.reduce(&:lcm)
    end
  end
end
