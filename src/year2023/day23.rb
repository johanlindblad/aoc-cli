module Year2023
  class Day23
    def part1(input)
      inpu2t = "#.#####################
#.......#########...###
#######.#########.#.###
###.....#.>.>.###.#.###
###v#####.#v#.###.#.###
###.>...#.#.#.....#...#
###v###.#.#.#########.#
###...#.#.#.......#...#
#####.#.#.#######.#.###
#.....#.#.#.......#...#
#.#####.#.#.#########v#
#.#...#...#...###...>.#
#.#.#v#######v###.###v#
#...#.>.#...>.>.#.###.#
#####v#.#.###v#.#.###.#
#.....#...#...#.#.#...#
#.#########.###.#.#.###
#...###...#...#...#.###
###.###.#.###v#####v###
#...#...#.#.>.>.#.>.###
#.###.###.#.###.#.#v###
#.....###...###...#...#
#####################.#"
      input = input.strip.split("\n").map(&:chars)

      maxy = input.length - 1
      maxx = input.first.length - 1

      pos = [0, 1]

      paths = [[pos, Set.new([pos]), 0]]
      max = 0
      slopes = {">" => [0, 1], "<" => [0, -1], "^" => [-1, 0], "v" => [1, 0]}
      dirs = slopes.values

      until paths.empty?
        pos, path, len = paths.shift
        y, x = pos

        if y == maxy && x == (maxx - 1)
          max = [max, len].max

          map = input.dup.map(&:dup)
          path.each do |p|
            py, px = p
            map[py][px] = "O"
          end
          map[y][x] = "!"

          #puts map.map(&:join).join("\n")
          #puts ""
          #puts len
          next
        end

        neighbours = dirs.map do |dir|
          dy, dx = dir
          ny, nx = y + dy, x + dx
          [ny, nx]
        end.select do |n|
          ny, nx = n
          ny >= 0 && nx >= 0 && ny <= maxy && nx <= maxx && input[ny][nx] != "#"
        end.reject do |n|
          path.include?(n)
        end.reject do |n|
          ny, nx = n
          dy = ny - y
          dx = nx - x
          slope = slopes[input[ny][nx]]
          slope != nil && (dy != slope.first || dx != slope.last)
        end

        neighbours.each do |n|
          ny, nx = n

          if slopes.keys.include?(input[ny][nx])
            npath = path.dup
            npath.add([ny, nx])
            sy, sx = slopes[input[ny][nx]]

            ny = ny + sy
            nx = nx + sx

            npath.add([ny, nx])
            paths.push([[ny, nx], npath, len + 2])
          else
            npath = path.dup
            npath.add([ny, nx])
            paths.push([[ny, nx], npath, len + 1])
          end

        end
      end

      max
    end

    def part2(input)
      inpu2t = "#.#####################
#.......#########...###
#######.#########.#.###
###.....#.>.>.###.#.###
###v#####.#v#.###.#.###
###.>...#.#.#.....#...#
###v###.#.#.#########.#
###...#.#.#.......#...#
#####.#.#.#######.#.###
#.....#.#.#.......#...#
#.#####.#.#.#########v#
#.#...#...#...###...>.#
#.#.#v#######v###.###v#
#...#.>.#...>.>.#.###.#
#####v#.#.###v#.#.###.#
#.....#...#...#.#.#...#
#.#########.###.#.#.###
#...###...#...#...#.###
###.###.#.###v#####v###
#...#...#.#.>.>.#.>.###
#.###.###.#.###.#.#v###
#.....###...###...#...#
#####################.#"
      input = input.strip.split("\n").map(&:chars)

      maxy = input.length - 1
      maxx = input.first.length - 1

      pos = [0, 1]

      paths = [[pos, Set.new([pos]), 0]]
      max = 0
      slopes = {">" => [0, 1], "<" => [0, -1], "^" => [-1, 0], "v" => [1, 0]}
      dirs = slopes.values

      g = {}

      (0..maxy).each do |y|
        (0..maxx).each do |x|
          neighbours = [[0, 1], [0, -1], [1, 0], [-1, 0]].map do |dd|
            dy, dx = dd
            ny = y + dy
            nx = x + dx
            [ny, nx, 1]
          end.select do |nn|
            ny, nx = nn
            ny >= 0 && ny <= maxy && nx >= 0 && nx >= 0 && nx <= maxx && input[ny][nx] != "#"
          end

          g[[y, x]] = neighbours if input[y][x] != "#"
        end
      end

      g.keys.each do |key|
        if g.has_key?(key)
          neighbours = g[key]
          y, x = key

          if neighbours.length == 2
            first, second = neighbours
            #puts "Y #{y} X #{x}"
            #puts "FIRST: #{first.inspect}"
            #puts "SECOND: #{second.inspect}"

            ny, nx, len = first
            ny2, nx2, len2 = second

            #puts "NY #{ny} NX #{nx} LEN #{len}"
            #puts "NY #{ny2} NX #{nx2} LEN #{len2}"
            #puts g.has_key?([ny, nx])
            #puts g.has_key?([ny2, nx2])

            #puts g[[ny, nx]].inspect

            raise "WTF1" unless g[[ny, nx]].delete([y, x, len])
            raise "WTF2" unless g[[ny2, nx2]].delete([y, x, len2])

            g[[ny, nx]].push([ny2, nx2, len + len2])
            g[[ny2, nx2]].push([ny, nx, len + len2])
            g.delete(key)
          end
        end
      end

      #puts g[[0, 1]].inspect
      #return g[[1, 1]].inspect
      g.keys.each do |key|
        g[key] = g[key].select do |n|
          y, x, len = n
          g.has_key?([y, x])
        end
      end

      g.keys.each do |key|
        puts "#{key}: #{g[key].inspect}"
      end
      #return g.select { |k,v| v.length > 1 }.inspect

      queue = [[g.keys.first, 0, Set.new]]
      max = 0


      until queue.empty?
        at, len, visited = queue.pop
        next if visited.include?(at)
        visited = visited.dup
        visited.add(at)

        if at.first == maxy
          max = [max, len].max
          puts "NEW MAX #{len}" if len == max
        end

        neighbours = g[at]

        neighbours.each do |n|
          y, x, l = n
          queue.push([[y, x], len + l, visited]) unless visited.include?([y, x])
        end
      end

      return max


      until paths.empty?
        pos, path, len = paths.shift
        y, x = pos

        if y == maxy && x == (maxx - 1)
          max = [max, len].max

          map = input.dup.map(&:dup)
          path.each do |p|
            py, px = p
            map[py][px] = "O"
          end
          map[y][x] = "!"
          next
        end

        neighbours = dirs.map do |dir|
          dy, dx = dir
          ny, nx = y + dy, x + dx
          [ny, nx]
        end.select do |n|
          ny, nx = n
          ny >= 0 && nx >= 0 && ny <= maxy && nx <= maxx && input[ny][nx] != "#"
        end.reject do |n|
          path.include?(n)
        end

        neighbours.each do |n|
          ny, nx = n

          npath = path.dup
          npath.add([ny, nx])
          paths.push([[ny, nx], npath, len + 1])

        end
      end

      max
    end
  end
end
