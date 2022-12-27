module Year2021
  class Day24
    def part1(input)
      params = input.split('inp')[1..].map do |section|
        vals = section.split(/\n|\s/).map(&:to_i)
        [vals[13], vals[16], vals[46]]
      end

      queue = { 0 => 0 }

      0.upto(13).each do |i|
        puts "digit #{i}, queue length #{queue.length}"
        next_queue = {}

        queue.each do |z_before, prefix|
          1.upto(9).each do |digit|
            cost = (prefix * 10) + digit
            z_after = z_value(params[i], digit, z_before)

            next_queue[z_after] = cost if !next_queue.key?(z_after) || next_queue[z_after] < cost
          end
        end

        queue = next_queue
      end

      queue[0]
    end

    def z_value(params, w, z)
      x = z % 26
      z = div(z, params[0])
      x += params[1]
      x = x != w ? 1 : 0
      y = x == 1 ? 26 : 1
      z *= y
      y = w + params[2]
      y *= x
      z += y
      z
    end

    def div(a, b)
      res = a.to_f / b
      if res < 0
        res.ceil
      else
        res.floor
      end
    end

    def part2(input)
      params = input.split('inp')[1..].map do |section|
        vals = section.split(/\n|\s/).map(&:to_i)
        [vals[13], vals[16], vals[46]]
      end

      queue = { 0 => 0 }

      0.upto(13).each do |i|
        puts "digit #{i}, queue length #{queue.length}"
        next_queue = {}

        queue.each do |z_before, prefix|
          1.upto(9).each do |digit|
            cost = (prefix * 10) + digit
            z_after = z_value(params[i], digit, z_before)

            next_queue[z_after] = cost if !next_queue.key?(z_after) || next_queue[z_after] > cost
          end
        end

        queue = next_queue
      end

      queue[0]
    end
  end
end
