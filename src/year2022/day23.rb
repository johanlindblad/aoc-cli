module Year2022
  class Day23
    def part1(input)

      inpu2t = "....#..
..###.#
#...#.#
.#...##
#.###..
##.#.##
.#..#.."
      inpu2t = ".....
..##.
..#..
.....
..##.
....."
      input = input.strip.split("\n").map(&:chars)

      map = {}

      input.each.with_index do |row, y|
        row.each.with_index do |col, x|
          map[[y, x]] = true if col == '#'
        end
      end

      # puts map.keys.inspect
      # min_y, max_y = map.keys.map(&:first).minmax
      # min_x, max_x = map.keys.map(&:last).minmax
      # 
      # (min_y - 1..max_y + 1).each do |y|
      # row = (min_x - 1..max_x + 1).map do |x|
      # if map[[y, x]] == true
      # '#'
      # else
      # '.'
      # end
      # end

      # puts row.join('')
      # end
      # puts ''


      direction_delta = 0

      n = 1

      loop do
        # First half
        directions = [[-1, 0], [1, 0], [0, -1], [0, 1]]
        directions += directions.shift(direction_delta)

        proposed = {}
        propositions = {}

        map.each_key do |coord|
          y, x = coord

          adjacent = [
            [-1, -1], [-1, 0], [-1, 1], 
            [0, -1], [0, 1], 
            [1, -1], [1, 0], [1, 1], 
          ]

          num_adjacent = adjacent.count do |a|
            dy, dx = a
            map[[y + dy, x + dx]]
          end

          next if num_adjacent == 0
          
          propositions[[y, x]] = directions.map do |direction|
            dy, dx = direction
            ds = [[dy, -1], [dy, 0], [dy, 1]] if dy != 0
            ds = [[-1, dx], [0, dx], [1, dx]] if dx != 0

            elves = ds.map do |d|
              ddy, ddx = d
              map[[y + ddy, x + ddx]]
            end.reject(&:nil?).count

            if elves == 0
              [y + dy, x + dx]
            end
          end.reject(&:nil?).first

          propositions[[y, x]] = propositions[[y, x]]

          ny, nx = propositions[[y, x]]
          proposed[[ny, nx]] ||= 0
          proposed[[ny, nx]] += 1
        end

        if proposed.count == 0
          puts "FINISHED AFTER #{n}"
          break
        end

        new_map = {}

        map.each_key do |elf|
          coord = propositions[elf]
          moved = false

          if proposed[coord] == 1 && moved == false
            new_map[coord] = true
            moved = true
          end

          new_map[elf] = true if moved == false
        end

        map = new_map

        direction_delta += 1
        direction_delta %= 4
        n += 1

        next

        min_y, max_y = map.keys.map(&:first).minmax
        min_x, max_x = map.keys.map(&:last).minmax

        (min_y - 1..max_y + 1).each do |y|
          row = (min_x - 1..max_x + 1).map do |x|
            if map[[y, x]] == true
              '#'
            else
              '.'
            end
          end

          puts row.join('')
        end
        puts ''
      end

      min_y, max_y = map.keys.map(&:first).minmax
      min_x, max_x = map.keys.map(&:last).minmax

      count = 0

      (min_y..max_y).each do |y|
        (min_x..max_x).each do |x|
          count += 1 if map[[y, x]] == true
        end
      end

      area = ((max_y - min_y).abs + 1) * ((max_x - min_x).abs + 1)

      puts [min_y, max_y].inspect
      puts [min_x, max_x].inspect

      area - count
    end

    def part2(input)
      nil
    end
  end
end
