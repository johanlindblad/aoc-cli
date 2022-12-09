module Year2022
  class Day09
    def part1(input)
      steps = input.strip.split("\n").map do |line|
        line = line.split(' ')
        [line[0], line[1].to_i]
      end

      hx = 0
      hy = 0

      tx = 0
      ty = 0

      visited = Set.new
      visited.add([tx, ty])

      steps.each do |step|
        step[1].times do
          case step[0]
          when 'R'
            hx += 1
          when 'L'
            hx -= 1
          when 'U'
            hy -= 1
          when 'D'
            hy += 1
          end

          touching = (hy == ty && hx == tx) ||
                     (hx == tx && (hy - ty).abs == 1) ||
                     (hy == ty && (hx - tx).abs == 1) ||
                     ((hy - ty).abs == 1 && (hx - tx).abs == 1)

          if !touching
            if hy == ty
              tx += (hx > tx) && 1 || -1
            elsif hx == tx
              ty += (hy > ty) && 1 || -1
            else
              tx += (hx > tx) && 1 || -1
              ty += (hy > ty) && 1 || -1
            end
          end

          visited.add([tx, ty])
        end
      end

      visited.count
    end

    def part2(input)
      steps = input.strip.split("\n").map do |line|
        line = line.split(' ')
        [line[0], line[1].to_i]
      end

      xs = [0] * 10
      ys = [0] * 10

      visited = Set.new()
      visited.add([xs.last, ys.last])

      steps.each do |step|
        step[1].times do
          case step[0]
          when 'R'
            xs[0] += 1
          when 'L'
            xs[0] -= 1
          when 'U'
            ys[0] -= 1
          when 'D'
            ys[0] += 1
          end

          1.upto(9).each do |n|
            hx = xs[n - 1]
            hy = ys[n - 1]

            tx = xs[n]
            ty = ys[n]

            touching = (hy == ty && hx == tx) ||
                       (hx == tx && (hy - ty).abs == 1) ||
                       (hy == ty && (hx - tx).abs == 1) ||
                       ((hy - ty).abs == 1 && (hx - tx).abs == 1)

            if !touching
              if hy == ty
                xs[n] += (hx > tx) && 1 || -1
              elsif hx == tx
                ys[n] += (hy > ty) && 1 || -1
              else
                xs[n] += (hx > tx) && 1 || -1
                ys[n] += (hy > ty) && 1 || -1
              end
            end
          end

          visited.add([xs.last, ys.last])
        end
      end

      visited.count
    end
  end
end
