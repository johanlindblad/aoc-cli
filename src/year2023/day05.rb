module Year2023
  class Day05
    def part1(input)
      input = input.strip.split("\n\n")

      seeds = input.shift.split(": ").last.split(" ").map(&:to_i).map do |i|
        Range.new(i, i + 1, true)
      end

      steps = input_to_steps(input)
      inner_solve(seeds, steps)
    end

    def part2(input)
      input = input.strip.split("\n\n")

      seeds = input.shift.split(": ").last.split(" ").map(&:to_i).each_slice(2).map do |slice|
        Range.new(slice.first, slice.first + slice.last, true)
      end

      steps = input_to_steps(input)
      inner_solve(seeds, steps)
    end

    def input_to_steps(input)
      input.map do |step|
        step = step.split("\n")

        step[1..].map do |s|
          destination, source, size = s.split(" ").map(&:to_i)
          to_range = Range.new(destination, destination + size, true)
          from_range = Range.new(source, source + size, true)
          [from_range, to_range]
        end
      end
    end

    def inner_solve(seeds, steps)
      output = steps.reduce(seeds) do |input, transformations|

        changed = []

        unchanged = transformations.reduce(input) do |input_ranges, transformation|
          from, to = transformation

          input_ranges.flat_map do |input_range|
            overlaps = self.ranges_overlap?(input_range, from)

            if overlaps
              diff = to.first - from.first

              first_overlap = [input_range.first, from.first].max
              last_overlap = [input_range.last, from.last].min

              new_input_range = Range.new(first_overlap + diff, last_overlap + diff, true)

              head = Range.new(input_range.first, first_overlap, true)
              head = nil if head.size == 0
              tail = Range.new(last_overlap, input_range.last, true)
              tail = nil if tail.size == 0

              changed.push(new_input_range)
              [head, tail].reject(&:nil?)
            else
              input_range
            end
          end
        end

        unchanged + changed
      end

      output.map(&:first).min
    end

    def ranges_overlap?(range_a, range_b)
      range_a.cover?(range_b.first) || range_a.cover?(range_b.last - 1) || range_b.cover?(range_a.first) || range_b.cover?(range_a.last - 1)
    end 
  end
end
