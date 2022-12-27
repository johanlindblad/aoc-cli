module Year2022
  class Day25
    def part1(input)
      input = input.strip.split("\n")

      sum = input.map do |line|
        digits = line.chars.reverse

        places = (0...digits.length).map { |n| 5**n }

        digits.zip(places).map do |part|
          char, place = part

          n = case char
              when '-'
                -1
              when '='
                -2
              else
                char.to_i
              end

          place * n
        end.sum
      end.sum

      snafu = ''

      until sum == 0
        rem = sum % 5

        case rem
        when 0..2
          snafu += rem.to_s
        when 3
          snafu += '='
          sum += 2
        when 4
          snafu += '-'
          sum += 1
        end

        sum /= 5
      end

      snafu.reverse
    end

    def part2(_input)
      nil
    end
  end
end
