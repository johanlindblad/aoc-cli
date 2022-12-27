module Year2022
  class Day17
    ROCKS = [
      "####",

      ".#.\n###\n.#.",

      "..#\n..#\n###",

      "#\n#\n#\n#",

      "##\n##"
    ].map do |rock|
      rock.split("\n").map(&:chars)
    end

    def part1(input)
      stream = input.strip.chars
      map = []
      stream_i = 0

      2022.times do |n|
        shape = ROCKS[n % ROCKS.length]
        (3 + shape.length).times do
          map.unshift('.......')
        end

        x_offset = 2
        y_offset = 0

        loop do
          direction = stream[stream_i % stream.length]
          stream_i += 1
          dir_dx = { '>' => 1, '<' => -1 }[direction]

          x_offset += dir_dx if works?(shape, map, x_offset + dir_dx, y_offset)

          break unless works?(shape, map, x_offset, y_offset + 1)

          y_offset += 1
        end

        overlay(shape, map, x_offset, y_offset)

        map.shift while map.first == '.......'
      end

      map.length
    end

    def works?(shape, map, x_offset, y_offset)
      if x_offset == -1
        return false
      elsif x_offset + shape.first.length > 7
        return false
      end

      if y_offset + shape.length > map.length
        return false
      end

      shape.to_enum.with_index.all? do |row, y|
        row.to_enum.with_index.all? do |col, x|
          map[y_offset + y][x_offset + x] == '.' || col == '.'
        end
      end
    end

    def overlay(shape, map, x_offset, y_offset)
      shape.each.with_index do |row, y|
        row.each.with_index do |col, x|
          map[y_offset + y][x_offset + x] = col if col == '#'
        end
      end
    end

    def part2(input)
      stream = input.strip.chars
      map = []
      stream_i = 0
      repeats = {}
      map_lengths = []

      5000.times do |n|
        puts n if n % 1000 == 0
        shape = ROCKS[n % ROCKS.length]
        (3 + shape.length).times do
          map.unshift('.......')
        end

        x_offset = 2
        y_offset = 0

        loop do
          direction = stream[stream_i % stream.length]
          stream_i += 1
          dir_dx = { '>' => 1, '<' => -1 }[direction]

          x_offset += dir_dx if works?(shape, map, x_offset + dir_dx, y_offset)

          break unless works?(shape, map, x_offset, y_offset + 1)

          y_offset += 1
        end

        overlay(shape, map, x_offset, y_offset)

        map.shift while map.first == '.......'
        map_lengths.push(map.length)

        chunks = {}

        map = map.reverse

        chunks_of = 20
        0.upto(map.length - chunks_of) do |offset|
          chunk = map[offset...(offset + chunks_of)]

          chunks[chunk] ||= []
          chunks[chunk].push(offset)
        end

        repeat = chunks.values.any? { |a| a.length > 1 }

        if repeat
          max = chunks.values.map(&:length).max
          repeats[max] ||= n
          break if max == 3
        end

        map = map.reverse
      end

      cycle_length = repeats[3] - repeats[2]
      cycle_diff = map_lengths[repeats[3]] - map_lengths[repeats[2]]

      index_diff = 1_000_000_000_000 - repeats[2]
      whole_cycles = index_diff / cycle_length
      extra_steps = index_diff % cycle_length

      length_before_repeats = map_lengths[repeats[2] + extra_steps]
      extra_steps = whole_cycles * cycle_diff

      length_before_repeats + extra_steps - 1 # -1 ?
    end
  end
end
