require 'set'

module Year2022
  class Day15
    def part1(input)
      return nil
      y = 2000000
      if false
        input = "Sensor at x=2, y=18: closest beacon is at x=-2, y=15
Sensor at x=9, y=16: closest beacon is at x=10, y=16
Sensor at x=13, y=2: closest beacon is at x=15, y=3
Sensor at x=12, y=14: closest beacon is at x=10, y=16
Sensor at x=10, y=20: closest beacon is at x=10, y=16
Sensor at x=14, y=17: closest beacon is at x=10, y=16
Sensor at x=8, y=7: closest beacon is at x=2, y=10
Sensor at x=2, y=0: closest beacon is at x=2, y=10
Sensor at x=0, y=11: closest beacon is at x=2, y=10
Sensor at x=20, y=14: closest beacon is at x=25, y=17
Sensor at x=17, y=20: closest beacon is at x=21, y=22
Sensor at x=16, y=7: closest beacon is at x=15, y=3
Sensor at x=14, y=3: closest beacon is at x=15, y=3
Sensor at x=20, y=1: closest beacon is at x=15, y=3"
        y = 10
      end
      input = input.strip.split("\n")

      sensors_beacons_radius = input.map do |line|
        parts = line.split(' ')
        sx = parts[2].split('=').last.gsub(',', '').to_i
        sy = parts[3].split('=').last.gsub(':', '').to_i
        bx = parts[8].split('=').last.gsub(',', '').to_i
        by = parts[9].split('=').last.to_i
        radius = (sx - bx).abs + (sy - by).abs

        [[sx, sy], [bx, by], radius]
      end

      map = {}

      sensor_xs = sensors_beacons_radius.map(&:first).map(&:first)
      xs1 = sensor_xs.min
      xs2 = sensor_xs.max

      blocked = Set.new

      sensors_beacons_radius.map do |item|
        sx, sy = item.first
        bx, by = item[1]
        radius = item.last

        lowest_radius = (sy - y).abs

        if lowest_radius <= radius
          remaining = radius - lowest_radius
          #puts "SENSOR BLOCKS #{remaining} with lowest radius #{lowest_radius} from #{sy}"

          (-remaining..remaining).each do |dx|
            blocked.add(sx + dx)
          end
        end
        
      end


      sensors_beacons_radius.each do |item|
        bx, by = item[1]

        if by == y
          blocked.delete(bx)
        end
      end
      

      puts blocked.count
      return nil

      sensors_beacons_radius.each do |item|
        sx, sy = item.first
        bx, by = item[1]
        radius = item.last

        map[[sx, sy]] = :sensor
        map[[bx, by]] = :beacon

        (-radius..radius).each do |dy|
          remaining = radius - dy.abs

          (-remaining..remaining).each do |dx|
            map[[sx + dx, sy + dy]] ||= :not_beacon
          end
        end


      end


      blocked = map.keys.select do |key|
        key.last == y
      end.select do |key|
        map[key] == :not_beacon
      end.count
    end

    def part2(input)
      x = 0
      y = 0

      inp2ut = "Sensor at x=2, y=18: closest beacon is at x=-2, y=15
Sensor at x=9, y=16: closest beacon is at x=10, y=16
Sensor at x=13, y=2: closest beacon is at x=15, y=3
Sensor at x=12, y=14: closest beacon is at x=10, y=16
Sensor at x=10, y=20: closest beacon is at x=10, y=16
Sensor at x=14, y=17: closest beacon is at x=10, y=16
Sensor at x=8, y=7: closest beacon is at x=2, y=10
Sensor at x=2, y=0: closest beacon is at x=2, y=10
Sensor at x=0, y=11: closest beacon is at x=2, y=10
Sensor at x=20, y=14: closest beacon is at x=25, y=17
Sensor at x=17, y=20: closest beacon is at x=21, y=22
Sensor at x=16, y=7: closest beacon is at x=15, y=3
Sensor at x=14, y=3: closest beacon is at x=15, y=3
Sensor at x=20, y=1: closest beacon is at x=15, y=3"
      input = input.strip.split("\n")

      beacons = Set.new
      sensors = {}

      sensors_beacons_radius = input.map do |line|
        parts = line.split(' ')
        sx = parts[2].split('=').last.gsub(',', '').to_i
        sy = parts[3].split('=').last.gsub(':', '').to_i
        bx = parts[8].split('=').last.gsub(',', '').to_i
        by = parts[9].split('=').last.to_i
        radius = (sx - bx).abs + (sy - by).abs

        beacons.add([bx, by])
        sensors[[sx, sy]] = radius

        [[sx, sy], [bx, by], radius]
      end

      possible_positions = Set.new

      sensors.keys.each do |key|
        sx, sy = key
        radius = sensors[key] + 1

        (-radius..radius).each do |dx|
          remaining = radius - dx
          possible_positions.add([sx + dx, sy + remaining]) if (sx + dx) >= 0 && (sx + dx) <= 4_000_000 && (sy + remaining) >= 0 && (sy + remaining) <= 4_000_000
          possible_positions.add([sx + dx, sy - remaining]) if (sx + dx) >= 0 && (sx + dx) <= 4_000_000 && (sy - remaining) >= 0 && (sy - remaining) <= 4_000_000
        end
      end

      possible_positions.each do |cor|
        x, y = cor

        works = true

        sensors.keys.each do |key|
          sx, sy = key
          radius = sensors[key]

          rr = (sx - x).abs + (sy - y).abs
          if rr <= radius
            works = false
            break
          end
        end

        if works
          puts "works:", [x, y].inspect
        end
      end

      return nil
      while y <= 4000000
        x = 0
        puts y

        while x <= 4000000

          remaining = sensors.keys.map do |s|
            sx, sy = s
            d = (sx - x).abs + (sy - y).abs
            remaining = sensors[s] - (sy - y).abs - (sx - x).abs
            remaining
          end
          #puts remaining.inspect

          max = remaining.max

          if max > 0
            x += (2 * remaining.max)
            x -= 1
          elsif max != 0
            puts remaining.inspect
            raise "WHAAAT #{y} #{x}"
          end

          x += 1
          #puts x if x%1000 == 0
        end
        
        y += 1
        puts (4_000_000 - y) if y%1000 == 0
      end



    end
  end
end
