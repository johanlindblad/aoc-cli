module Year2022
  class Day16
    def part1(input)
      input = input.strip.split("\n")

      flows = {}
      neighbours = {}

      input.each do |line|
        parts = line.split(' ')
        name = parts[1]
        flow = parts[4].split('=').last.gsub(';', '').to_i
        flows[name] = flow

        tunnels = parts[9..].map { |part| part.gsub(',', '') }
        tunnels.each do |tunnel|
          neighbours[name] ||= []
          neighbours[name].push(tunnel)
        end
      end

      open = {}
      place = 'AA'
      total_flow = 0
      minutes_left = 29
      back_from = nil

      max_flow = 0

      queue = [[total_flow, place, minutes_left, open, back_from]]

      until queue.empty?
        item = queue.shift
        total_flow, place, minutes_left, open, back_from = item
        max_flow = [max_flow, total_flow].max

        options = neighbours[place]

        next if minutes_left * flows.values.max < (max_flow - total_flow)

        if minutes_left >= 2
          new_minutes_left = minutes_left - 1
          options.each do |option|
            next if option == back_from

            queue.push([total_flow, option, new_minutes_left, open, place])
          end
        end

        if !open.include?(place) && minutes_left >= 2 && flows[place] > 0
          new_open = open.dup
          new_open[place] = minutes_left
          new_minutes_left = minutes_left - 1
          extra_flow = minutes_left * flows[place]
          new_minutes_left -= 1
          new_total_flow = total_flow + extra_flow

          options.each do |option|
            queue.push([new_total_flow, option, new_minutes_left, new_open, place])
          end
        end
      end

      max_flow
    end

    def part2(input)
      input = input.strip.split("\n")

      flows = {}
      neighbours = {}

      input.each do |line|
        parts = line.split(' ')
        name = parts[1]
        flow = parts[4].split('=').last.gsub(';', '').to_i
        flows[name] = flow

        tunnels = parts[9..].map { |part| part.gsub(',', '') }
        tunnels.each do |tunnel|
          neighbours[name] ||= []
          neighbours[name].push(tunnel)
        end
      end

      open = {}
      place = 'AA'
      place2 = 'AA'
      total_flow = 0
      minutes_left = 25
      back_from = nil
      back_from2 = nil

      max_flow = 0

      queue = [[total_flow, place, place2, minutes_left, open, back_from, back_from2]]

      until queue.empty?
        item = queue.shift
        total_flow, place, place2, minutes_left, open, back_from, back_from2 = item

        max_flow = [max_flow, total_flow].max

        options = neighbours[place]
        options2 = neighbours[place2]

        next if 2 * minutes_left * flows.values.max < (max_flow - total_flow)

        can_open = !open.key?(place) && flows[place] > 0
        can_open2 = !open.key?(place2) && flows[place2] > 0

        if can_open
          new_open = open.dup
          new_open[place] = minutes_left
          extra_flow = minutes_left * flows[place]

          options2.each do |option2|
            next if back_from2 == option2

            queue.push([total_flow + extra_flow, place, option2, minutes_left - 1, new_open, nil, place2])
          end

          if can_open2 && place != place2
            new_open = new_open.dup
            new_open[place2] = minutes_left
            extra_extra_flow = minutes_left * flows[place2]
            queue.push([total_flow + extra_flow + extra_extra_flow, place, place2, minutes_left - 1, new_open, nil, nil])
          end
        elsif can_open2
          new_open = open.dup
          new_open[place2] = minutes_left
          extra_flow = minutes_left * flows[place2]
          options.each do |option|
            next if back_from == option

            queue.push([total_flow + extra_flow, option, place2, minutes_left - 1, new_open, place, nil])
          end
        end

        options.each do |option|
          next if back_from == option

          options2.each do |option2|
            next if back_from2 == option2

            queue.push([total_flow, option, option2, minutes_left - 1, open, place, place2])
          end
        end
      end

      max_flow
    end
  end
end
