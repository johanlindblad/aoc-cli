module Year2022
  class Day02
    def part1(input)
      input = input.split("\n")

      input.map do |line|
        line = line.split(" ")
        x, y = line
        winp = 0
        selp = 0

        if y == "X"
          selp += 1
        elsif y == "Y"
          selp += 2
        else
          selp += 3
        end

        y = "A" if y == "X"
        y = "B" if y == "Y"
        y = "C" if y == "Z"

        if (x == "A" && y == "B") || (x == "B" && y == "C") || (x == "C" && y == "A")
          winp += 6
        elsif (x == "A" && y == "A") || (x == "B" && y == "B") || (x == "C" && y == "C")
          winp += 3
        end
        puts [winp, selp].inspect

        winp + selp
      end.sum
    end

    def part2(input)
      input = input.split("\n")


      input.map do |line|
        line = line.split(" ")
        x, y = line
        winp = 0
        selp = 0
        choice = nil
        choices = ['A', 'B', 'C']

        oindex = ['A', 'B', 'C'].find_index(x)
        if y == "Z"
          choice = choices[(oindex + 1) % 3]
          winp += 6
        elsif y == "Y"
          choice = choices[oindex]
          winp += 3
        else
          choice = choices[(3 + oindex - 1) % 3]
        end


        if choice == "A"
          selp += 1
        elsif choice == "B"
          selp += 2
        else
          selp += 3
        end

        puts [winp, selp].inspect
        puts choice
        puts "--"

        winp + selp
      end.sum
    end
  end
end
