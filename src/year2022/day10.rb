module Year2022
  class Day10
    def part1(input)
      input = input.strip.split("\n")

      x = 1
      cycle = 0

      signal_strengths = []

      input.each do |line|
        if line == 'noop'
          cycle += 1

          signal_strengths.push(x * cycle) if cycle == 20 || (cycle > 20 && ((cycle - 20) % 40).zero?)
        else
          amount = line.split(' ').last.to_i

          cycle += 1
          signal_strengths.push(x * cycle) if cycle == 20 || (cycle > 20 && ((cycle - 20) % 40).zero?)

          cycle += 1
          signal_strengths.push(x * cycle) if cycle == 20 || (cycle > 20 && ((cycle - 20) % 40).zero?)
          x += amount
        end
      end

      signal_strengths.sum
    end

    def part2(input)
      input = input.strip.split("\n")

      x = 1
      cycle = 0
      screen = []
      buffer = ' ' * 40

      signal_strengths = []

      input.each do |line|
        if line == 'noop'
          drawing = cycle % 40
          buffer[drawing] = '#' if [drawing - 1, drawing, drawing + 1].include?(x)
          screen.push(buffer) if drawing == 39
          buffer = ' ' * 40 if drawing == 39

          cycle += 1

          signal_strengths.push(x * cycle) if cycle == 20 || (cycle > 20 && ((cycle - 20) % 40).zero?)
        else
          amount = line.split(' ').last.to_i
          drawing = cycle % 40
          buffer[drawing] = '#' if [drawing - 1, drawing, drawing + 1].include?(x)
          screen.push(buffer) if drawing == 39
          buffer = ' ' * 40 if drawing == 39

          cycle += 1
          signal_strengths.push(x * cycle) if cycle == 20 || (cycle > 20 && ((cycle - 20) % 40).zero?)

          drawing = cycle % 40
          buffer[drawing] = '#' if [drawing - 1, drawing, drawing + 1].include?(x)
          screen.push(buffer) if drawing == 39
          buffer = ' ' * 40 if drawing == 39

          cycle += 1
          signal_strengths.push(x * cycle) if cycle == 20 || (cycle > 20 && ((cycle - 20) % 40).zero?)

          x += amount
        end
      end

      screen
    end
  end
end
