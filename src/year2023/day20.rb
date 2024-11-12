module Year2023
  class Day20
    def part1(input)
      input2 = "broadcaster -> a, b, c
%a -> b
%b -> c
%c -> inv
&inv -> a
"

      input2 = "broadcaster -> a
%a -> inv, con
&inv -> b
%b -> con
&con -> output"

      debug = false
      debug2 = false

      neighbors = {}
      reverse_neighbors = {}
      nodes = {}

      input.split("\n").each do |line|
        name, connections = line.split(" -> ")

        if name.start_with?("&")
          name = name[1..]
          nodes[name] = [:conjunction, Set.new]
        elsif name.start_with?("%")
          name = name[1..]
          nodes[name] = [:flip_flop, false]
        else
          nodes[name] = [:broadcaster]
        end

        connections.split(", ").each do |neighbor|
          neighbors[name] ||= []
          neighbors[name].push(neighbor)
          reverse_neighbors[neighbor] ||= []
          reverse_neighbors[neighbor].push(name)
        end
      end

      if debug2
        puts nodes.inspect
        puts neighbors.inspect
        puts reverse_neighbors.inspect
      end

      counts = { true => 0, false => 0 }

      1000.times do
        queue = [["button", "broadcaster", false]]

        until queue.empty?
          from, name, signal = queue.shift

          counts[signal] += 1

          node = nodes[name]

          puts "#{from} -#{signal ? 'high' : 'low'}-> #{name}" if debug

          next if node.nil?

          case node.first
          when :broadcaster
            neighbors[name].each do |neighbor|
              queue.push([name, neighbor, signal])
            end

          when :flip_flop
            if signal == false
              node[-1] = !node[-1]
              puts "-- #{name} is now #{node[-1] ? 'high' : 'low'}" if debug2
              neighbors[name].each do |neighbor|
                queue.push([name, neighbor, node.last])
              end
            end

          when :conjunction
            node.last.delete(from)
            node.last.add(from) if signal == true
            new_state = node.last.length != reverse_neighbors[name].length
            # puts node.last.inspect
            # puts reverse_neighbors[name].inspect
            # puts "--"
            if debug2
              puts "-- #{name} is now #{new_state ? 'high' : 'low'} - high are (#{node.last.inspect}) out of (#{reverse_neighbors[name]})"
            end

            neighbors[name].each do |neighbor|
              queue.push([name, neighbor, new_state])
            end
          else
            raise node.first.inspect
          end
        end
      end

      counts.values.inject(&:*)
    end

    def part2(input)
      debug = false
      debug2 = false

      neighbors = {}
      reverse_neighbors = {}
      nodes = {}

      input.split("\n").each do |line|
        name, connections = line.split(" -> ")

        if name.start_with?("&")
          name = name[1..]
          nodes[name] = [:conjunction, Set.new]
        elsif name.start_with?("%")
          name = name[1..]
          nodes[name] = [:flip_flop, false]
        else
          nodes[name] = [:broadcaster]
        end

        connections.split(", ").each do |neighbor|
          neighbors[name] ||= []
          neighbors[name].push(neighbor)
          reverse_neighbors[neighbor] ||= []
          reverse_neighbors[neighbor].push(name)
        end
      end

      if debug2
        puts nodes.inspect
        puts neighbors.inspect
        puts reverse_neighbors.inspect
      end

      rx_antecedent = reverse_neighbors["rx"].first
      antecedents = reverse_neighbors[rx_antecedent]

      counts = { true => 0, false => 0 }
      buttons = 0
      a_counts = {}

      loop do
        queue = [["button", "broadcaster", false]]
        buttons += 1

        until queue.empty?
          from, name, signal = queue.shift
          counts[signal] += 1
          node = nodes[name]
          puts "#{from} -#{signal ? 'high' : 'low'}-> #{name}" if debug

          if antecedents.include?(from) && signal == true
            a_counts[from] ||= buttons
            return a_counts.values.inject(1, :lcm) if a_counts.length == antecedents.length
          end

          next if node.nil?

          case node.first
          when :broadcaster
            neighbors[name].each do |neighbor|
              queue.push([name, neighbor, signal])
            end

          when :flip_flop
            if signal == false
              node[-1] = !node[-1]
              neighbors[name].each do |neighbor|
                queue.push([name, neighbor, node.last])
              end
            end

          when :conjunction
            node.last.delete(from)
            node.last.add(from) if signal == true
            new_state = node.last.length != reverse_neighbors[name].length

            neighbors[name].each do |neighbor|
              queue.push([name, neighbor, new_state])
            end
          else
            raise node.first.inspect
          end
        end
      end

      counts.values.inject(&:*)
    end
  end
end
