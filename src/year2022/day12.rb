module Year2022
  class Day12
    def part1(input)
      in2put = "Sabqponm
abcryxxl
accszExk
acctuvwj
abdefghi"
      map = input.strip.split("\n").map(&:chars)

      start = nil
      map.each.with_index do |row, y|
        x = row.find_index { |c| c == ('S') }

        if !x.nil?
          start = [y, x]
        end
      end

      map[start.first][start.last] = 'a'

      width = map.first.length
      height = map.length

      queue = [[start.first, start.last, 0]]

      visited = map.map do |row|
        row.map { 1_000_000_000 }
      end
      visited[0][0] = 0

      e = nil

      until queue.empty? do
        y, x, steps = queue.shift

        elevation = map[y][x]

        if elevation == 'E'
          e = [y, x]
          #return steps
        end

        if x > 0 && allowed(elevation, map[y][x - 1]) && visited[y][x - 1] > steps + 1
          puts "LEFT" if map[y][x - 1] == 'E'
          visited[y][x - 1] = steps + 1
          queue.push([y, x - 1, steps + 1])
        end

        if x < (width - 1) && allowed(elevation, map[y][x + 1]) && visited[y][x + 1] > steps + 1
          puts "RIGHT" if map[y][x + 1] == 'E'
          visited[y][x + 1] = steps + 1
          queue.push([y, x + 1, steps + 1])
        end

        if y > 0 && allowed(elevation, map[y - 1][x]) && visited[y - 1][x] > steps + 1
          puts "UP from #{elevation} to #{map[y - 1][x]}" if map[y - 1][x] == 'E'
          visited[y - 1][x] = steps + 1
          queue.push([y - 1, x, steps + 1])
        end

        if y < (height - 1) && allowed(elevation, map[y + 1][x]) && visited[y + 1][x] > steps + 1
          puts "DOWN" if map[y + 1][x] == 'E'
          visited[y + 1][x] = steps + 1
          queue.push([y + 1, x, steps + 1])
        end
      end

      puts e.inspect
      puts visited[e.first][e.last]
    end

    def allowed(from, to)
      return true if to == 'E' && (from == 'z' || from == 'y')
      return false if to == 'E'

      to.ord <= from.ord || (to.ord - from.ord) == 1
    end

    def part2(input)
      in2put = "Sabqponm
abcryxxl
accszExk
acctuvwj
abdefghi"
      map = input.strip.split("\n").map(&:chars)

      start = nil
      map.each.with_index do |row, y|
        x = row.find_index { |c| c == ('E') }

        if !x.nil?
          start = [y, x]
        end
      end

      map[start.first][start.last] = 'z'

      width = map.first.length
      height = map.length

      queue = [[start.first, start.last, 0]]

      visited = map.map do |row|
        row.map { 1_000_000_000 }
      end
      visited[0][0] = 0

      e = nil

      until queue.empty? do
        y, x, steps = queue.shift

        elevation = map[y][x]

        if elevation == 'a'
          e = [y, x]
          return steps
        end

        if x > 0 && allowed2(elevation, map[y][x - 1]) && visited[y][x - 1] > steps + 1
          visited[y][x - 1] = steps + 1
          queue.push([y, x - 1, steps + 1])
        end

        if x < (width - 1) && allowed2(elevation, map[y][x + 1]) && visited[y][x + 1] > steps + 1
          visited[y][x + 1] = steps + 1
          queue.push([y, x + 1, steps + 1])
        end

        if y > 0 && allowed2(elevation, map[y - 1][x]) && visited[y - 1][x] > steps + 1
          visited[y - 1][x] = steps + 1
          queue.push([y - 1, x, steps + 1])
        end

        if y < (height - 1) && allowed2(elevation, map[y + 1][x]) && visited[y + 1][x] > steps + 1
          visited[y + 1][x] = steps + 1
          queue.push([y + 1, x, steps + 1])
        end
      end

      puts e.inspect
      puts visited[e.first][e.last]
    end
    def allowed2(from, to)
      return true if to == 'a' && (from == 'a' || from == 'b')
      return false if to == 'a'

      to.ord >= from.ord || (from.ord - to.ord) == 1
    end
  end
end
