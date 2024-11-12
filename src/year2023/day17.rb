require 'pqueue'
require 'set'

module Year2023
  class Day17
    def part1(input)
      input = input.strip.split("\n").map(&:chars).map { _1.map(&:to_i) }
      solve(input, 0, 3)
    end

    def part2(input)
      input = input.strip.split("\n").map(&:chars).map { _1.map(&:to_i) }
      solve(input, 3, 10)
    end

    def solve(input, min_streak, max_streak)
      maxy = input.length
      maxx = input.first.length

      pq = PQueue.new([]){ |a,b| b <=> a }

      # cost, (x, y), (dx, dy), streak
      pq.push([0, [0, 0], [0, 1], 0])
      pq.push([0, [0, 0], [1, 0], 0])
      visited = Set.new
      target = [maxy - 1, maxx - 1]

      loop do
        item = pq.pop
        cost, pos, dir, streak = item
        y, x = pos
        dy, dx = dir

        return cost if [y, x] == target && streak >= min_streak
        next if visited.include?([pos, dir, streak])
        visited.add([pos, dir, streak])

        # Straight
        if streak < (max_streak - 1) && (y + dy) >= 0 && (y + dy) < maxy && (x + dx) >= 0 && (x + dx) < maxx
          ny, nx = y + dy, x + dx
          new_cost = cost + input[ny][nx]
          new_item = [new_cost, [ny, nx], dir, streak + 1]
          pq.push(new_item) unless visited.include?(new_item)
        end

        # Turn
        if streak >= min_streak
          ldir = [-dx, dy]
          ly, lx = y + ldir.first, x + ldir.last
          rdir = [dx, -dy]
          ry, rx = y + rdir.first, x + rdir.last

          if ly >= 0 && ly < maxy && lx >= 0 && lx < maxx
            new_cost = cost + input[ly][lx]
            new_item = [new_cost, [ly, lx], ldir, 0]
            pq.push(new_item) unless visited.include?(new_item)
          end
          if ry >= 0 && ry < maxy && rx >= 0 && rx < maxx
            new_cost = cost + input[ry][rx]
            new_item = [new_cost, [ry, rx], rdir, 0]
            pq.push(new_item) unless visited.include?(new_item)
          end
        end
      end
    end
  end
end
