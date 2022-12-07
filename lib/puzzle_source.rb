require 'benchmark'

# Manage a solution's source file for a given day
class PuzzleSource
  def self.create_puzzle(year, day)
    padded_day = Day.pad(day)
    begin
      Module.const_get("Year#{year}").const_get("Day#{padded_day}").new
    rescue NameError
      puts 'There is no solution for this puzzle'
    end
  end

  def self.run_part(part_name)
    has_result = false
    t = Benchmark.realtime do
      solution = yield
      if !solution.nil?
        puts "Result for #{part_name}:"
        puts solution
        has_result = true
      else
        puts "no result for #{part_name}"
      end
    end
    puts "(obtained in #{t} seconds)" if has_result
  end

  def self.puzzle_source_directory(year)
    File.join('src', "year#{year}")
  end

  def self.puzzle_source_path(year, day)
    day = Day.pad(day)
    File.join(puzzle_source_directory(year), "day#{day}.rb")
  end

  def self.puzzle_source(year, day)
    day = Day.pad(day)

    <<~TPL
      module Year#{year}
        class Day#{day}
          def part1(input)
            # input = input.strip.split("\\n")
            # input = input.strip.split("\\n").map(&:to_i)
            # input = input.strip.split("\\n").map(&:chars)
            # input = input.strip.split("\\n").map{|l| l.split(" ")}
            # input = input.strip.chars
            "expected_result"
          end

          def part2(input)
            nil
          end
        end
      end
    TPL
  end
end
