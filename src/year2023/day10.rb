require 'set'

module Year2023
  class Day10
    def part1(input)
      input = input.strip.split("\n").map(&:chars)

      neighbours = {}
      sy, sx = nil, nil

      (0...input.length).each do |y|
        neighbours[y] ||= {}

        (0...input.first.length).each do |x|
          neighbours[y][x] = case input[y][x]
          when "|"
            [[y-1, x], [y+1, x]]
          when "-"
            [[y, x-1], [y, x+1]]
          when "L"
            [[y-1, x], [y, x+1]]
          when "J"
            [[y-1, x], [y, x-1]]
          when "7"
            [[y+1, x], [y, x-1]]
          when "F"
            [[y+1, x], [y, x+1]]
          when "."
            nil
          when "S"
            sy, sx = y, x
            nil
          end
        end
      end

      neighbours[sy][sx] = [[sy-1, sx], [sy+1, sx], [sy, sx-1], [sy, sx+1]].select do |n|
        y, x = n
        !neighbours[y][x].nil? && neighbours[y][x].include?([sy, sx])
      end

      visited = Set.new
      queue = [[sy, sx]]
      distance = {[sy, sx] => 0}

      until queue.empty? do
        y, x = queue.shift
        d = distance[[y, x]]

        neighbours[y][x].each do |n|
          ny, nx = n

          if !distance.has_key?(n)
            distance[n] = d + 1
            queue.push(n)
          end
        end
      end

      distance.values.max
    end

    def part2(input)
      input = input.strip.split("\n").map(&:chars)

      neighbours = {}
      sy, sx = nil, nil

      newinput = 0.upto((input.length - 1) * 2).map { (" " * input.first.length * 2).chars }

      (0...input.length).each do |y|
        ny = y * 2
        neighbours[ny] ||= {}

        (0...input.first.length).each do |x|
          nx = x * 2

          neighbours[ny][nx] = case input[y][x]
          when "|"
            [[ny - 2, nx], [ny + 2, nx]]
          when "-"
            [[ny, nx-2], [ny, nx + 2]]
          when "L"
            [[ny-2, nx], [ny, nx + 2]]
          when "J"
            [[ny - 2, nx], [ny, nx - 2]]
          when "7"
            [[ny + 2, nx], [ny, nx-2]]
          when "F"
            [[ny+2, nx], [ny, nx+2]]
          when "."
            nil
          when "S"
            sy, sx = ny, nx
            [[ny+2, nx], [ny-2, nx], [ny, nx-2], [ny, nx+2]]
          end
        end
      end

      maxy = newinput.length - 1
      maxx = newinput.first.length - 1

      neighbours.keys.each do |y|
        neighbours[y].keys.each do |x|
          if neighbours[y][x] != nil
            neighbours[y][x] = neighbours[y][x].select do |nn|
              ny, nx = nn
              neighbours[ny] != nil && neighbours[ny][nx] != nil && neighbours[ny][nx].include?([y, x])
            end
          end
        end
      end

      visited = Set.new
      queue = [[sy, sx]]

      until queue.empty? do
        y, x = queue.shift
        next if visited.include?([y, x])
        visited.add([y, x])

        neighbours[y][x].each do |n|
          ny, nx = n
          queue.push(n) unless visited.include?([ny, nx])
        end
      end

      neighbours.keys.each do |y|
        neighbours[y].keys.each do |x|
          if visited.include?([y, x])
            newinput[y][x] = "#"

            neighbours[y][x].each do |nn|
              ny, nx = nn
              if (ny - y) == 2
                newinput[y + 1][x] = "#"
              elsif (ny - y) == -2
                newinput[y - 1][x] = "#"
              elsif (nx - x) == 2
                newinput[y][x + 1] = "#"
              elsif (nx - x) == -2
                newinput[y][x - 1] = "#"
              end
            end
          else
            neighbours[y][x] = nil
            newinput[y][x] = " "
          end
        end
      end

      open = 0.upto(maxy).to_a.product(0.upto(maxx).to_a).select do |n|
        y, x = n
        newinput[y][x] != "#"
      end

      start = open.select do |n|
        y, x = n
        (y == 0 || y == maxy) || (x == 0 || x == maxx)
      end

      queue = start
      visited = Set.new

      until queue.empty?
        n = queue.shift
        next if visited.include?(n)
        visited.add(n)

        y, x = n
        newinput[y][x] = "*"

        neighbours = [[0, -1], [0, 1], [-1, 0], [1, 0], [1, 1], [-1, -1], [1, -1], [-1, 1]]
          .map do |d|
            ny, nx = d
            [y - ny, x - nx]
          end
          .select do |nn|
            ny, nx = nn
            ny >= 0 && ny <= maxy && nx >= 0 && nx <= maxx
          end
          .reject do |nn|
            visited.include?(nn)
          end
          .reject do |nn|
            ny, nx = nn
            newinput[ny][nx] == "#"
          end

        queue.push(*neighbours)
      end

      remaining = (open - visited.to_a)
        .select do |n|
          y, x = n
          y.even? && x.even?
        end

      remaining.length
    end
  end
end
