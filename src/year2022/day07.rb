module Year2022
  class Day07
    def part1(input)
      input = input.strip.split("\n")

      drive = {}
      path = []
      dirs = []

      until input.empty?
        line = input.shift
        break if line.nil?

        cmd = line.split(' ')

        if cmd[1] == 'cd'
          if cmd[2] == '..'
            path.pop
          else
            path.push(cmd[2])
            dirs += [path.dup]
          end
        else
          # cmd[1] == 'ls'
          loop do
            output = input.shift

            if output.nil? || output[0] == '$'
              input.unshift(output)
              break
            else
              parts = output.split(' ')

              if parts[0] == 'dir'
                dig_set(drive, path + [parts[1]], {})
              else
                dig_set(drive, path + [parts[1]], parts[0].to_i)
              end
            end
          end
        end
      end

      sizes = dirs.map do |dir|
        size(drive, dir)
      end

      sizes.select do |size|
        size <= 100_000
      end.sum
    end

    def dig_set(obj, keys, value)
      key = keys.first
      if keys.length == 1
        obj[key] = value
      else
        obj[key] = {} unless obj[key]
        dig_set(obj[key], keys.slice(1..-1), value)
      end
    end

    def size(drive, path)
      drive.dig(*path).map do |key, value|
        if value.is_a? Integer
          value
        else
          size(drive, path + [key])
        end
      end.sum
    end


    def part2(input)
      input = input.strip.split("\n")

      drive = {}
      path = []
      dirs = []

      until input.empty?
        line = input.shift
        break if line.nil?

        cmd = line.split(' ')

        if cmd[1] == 'cd'
          if cmd[2] == '..'
            path.pop
          else
            path.push(cmd[2])
            dirs += [path.dup]
          end
        else
          # cmd[1] == 'ls'
          loop do
            output = input.shift

            if output.nil? || output[0] == '$'
              input.unshift(output)
              break
            else
              parts = output.split(' ')

              if parts[0] == 'dir'
                dig_set(drive, path + [parts[1]], {})
              else
                dig_set(drive, path + [parts[1]], parts[0].to_i)
              end
            end
          end
        end
      end

      used = size(drive, ['/'])
      required = 30_000_000
      remaining = 70_000_000 - used
      to_free = required - remaining

      candidates = dirs.select do |dir|
        size(drive, dir) >= to_free
      end

      candidates.map do |dir|
        size(drive, dir)
      end.min
    end
  end
end
