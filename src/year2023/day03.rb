module Year2023
  class Day03
    def part1(input)
      input = input.strip.split("\n").map(&:chars)

      adjacent = input.map.with_index do |row, y|
        row.map.with_index do |char, x|
          neigh = [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]].map do |pair|
            dy, dx = pair
            [dy + y, dx + x]
          end.reject do |pair|
            pair.first < 0 || pair.last < 0 || pair.first >= input.length || pair.last >= input.first.length
          end.map do |pair|
            ny, nx = pair
            input[ny][nx]
          end
        end
      end

      parts = []

      adjacent.each.with_index do |row, y|
        i = 0
        
        while i < input[y].length do
          taken = 1

          if /[0-9]/.match?(input[y][i])
            number = []
            adj = []

            number.push(input[y][i])
            adj.push(adjacent[y][i])
            j = i + 1

            while /[0-9]/.match?(input[y][j]) && j <= input[y].length do
              number.push(input[y][j])
              adj.push(adjacent[y][j])
              taken += 1
              j += 1
            end

            part = adj.any? do |a|
              !a.all? do |char|
                char == "." || /[0-9]/.match?(char)
              end
            end

            if part
              parts.push(number.join(""))
            end
          end

          i += taken
        end
      end

      parts.map(&:to_i).sum
    end

    def part2(input)
      input = input.strip.split("\n").map(&:chars)

      adjacent = input.map.with_index do |row, y|
        row.map.with_index do |char, x|
          neigh = [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]].map do |pair|
            dy, dx = pair
            [dy + y, dx + x]
          end.reject do |pair|
            pair.first < 0 || pair.last < 0 || pair.first >= input.length || pair.last >= input.first.length
          end
        end
      end

      parts = []

      gears = []
      input.each.with_index do |row, y|
        input[y].each.with_index do |char, x|
          if char == "*"
            gears.push([y, x])
          end
        end
      end

      at_gears = {}
      adjacent.each.with_index do |row, y|
        i = 0
        
        while i < input[y].length do
          taken = 1

          if /[0-9]/.match?(input[y][i])
            number = []
            adj = []

            number.push(input[y][i])
            adj.push(adjacent[y][i])
            j = i + 1

            while /[0-9]/.match?(input[y][j]) && j <= input[y].length do
              number.push(input[y][j])
              adj.push(adjacent[y][j])
              j += 1
            end
            taken = j - i

            gear = nil
            adj.each do |a|
              a.each do |pair|
                gear = pair if input[pair.first][pair.last] == "*"
              end
            end

            if gear
              at_gears[gear] ||= []
              at_gears[gear].push(number.join(""))
            end
          end

          i += taken
        end
      end

      at_gears
        .values
        .reject { |numbers| numbers.length != 2}
        .map { |numbers| numbers.map(&:to_i).reduce(&:*) }
        .sum
    end
  end
end
