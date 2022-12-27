module Year2022
  class Day19
    def part1(input)
      i2nput = "Blueprint 1: Each ore robot costs 4 ore. Each clay robot costs 2 ore. Each obsidian robot costs 3 ore and 14 clay. Each geode robot costs 2 ore and 7 obsidian.
Blueprint 2: Each ore robot costs 2 ore. Each clay robot costs 3 ore. Each obsidian robot costs 3 ore and 8 clay. Each geode robot costs 3 ore and 12 obsidian."
      input = input.strip.split("\n").map { |line| line.split(' ').map(&:to_i).reject(&:zero?) }

      return nil

      # state = [ minutes_left, [ore, clay, obsidian, geode], [ore_collecting, clay_collecting, obsidian_collecting, geode_collecting], [robot_order]]
      #
      total = 0

      input.each.with_index do |blueprint, index|
        state = [24, [0, 0, 0, 0], [1, 0, 0, 0] ]
        max = 0
        queue = [state]

        puts blueprint.inspect

        costs = [
          [-blueprint[1], 0, 0, 0],
          [-blueprint[2], 0, 0, 0], 
          [-blueprint[3], -blueprint[4], 0, 0],
          [-blueprint[5], 0, -blueprint[6], 0]
        ]

        max_geodes = {}
        seen = {}

        until queue.empty?
          state = queue.shift
          minutes, amounts, robots = state
          max = [max, amounts.last].max

          #puts minutes
          next if minutes.zero?

          ore, clay, obsidian, geode = amounts
          ore_collecting, clay_collecting, obsidian_collecting, geode_collecting = robots

          #puts "min: #{minutes}, max: #{max}"

          max_geodes[minutes] ||= 0

          next if max_geodes[minutes] > geode

          max_geodes[minutes] = geode if geode > max_geodes[minutes]

          amounts_after_costs = costs.map do |cost|
            amounts.zip(cost).map(&:sum)
          end

          robot = false

          costs.each.with_index do |cost, i|
            c = amounts.zip(cost).map(&:sum)
            possible = c.none?(&:negative?)

            geode_possible = amounts_after_costs.last.none?(&:negative?)
            obsidian_possible = amounts_after_costs[2].none?(&:negative?)

            possible = false if geode_possible && i < 3
            possible = false if obsidian_possible && i < 2
            possible = false if i == 0 && ore_collecting >= -costs.map(&:first).min
            possible = false if i == 1 && clay_collecting >= -costs.map{ |c| c[1] }.min

            if possible
              robot = true
              new_amounts = c
              new_amounts = new_amounts.zip(robots).map(&:sum)
              new_robots = robots.dup
              new_robots[i] += 1

              # puts "amount_before #{amounts}"
              # puts "amount_after #{new_amounts}"
              # puts "robots #{robots}"
              # puts "c #{c}"
              # puts "--"
              # unless seen.key?(new_robots_order) && seen[new_robots_order.sort] > minutes
              unless seen.key?([minutes - 1, new_amounts, new_robots])
                queue.push([minutes - 1, new_amounts, new_robots])
              end
              seen[[minutes - 1, new_amounts, new_robots]] = true
              # seen[new_robots_order.sort] = minutes
            end
          end

          next if ore > minutes * -costs.map(&:first).min

          next if clay > minutes * -costs.map{ |c| c[1] }.min
          
          new_amounts = amounts.zip(robots).map(&:sum)
          queue.push([minutes - 1, new_amounts, robots]) unless seen.key?([minutes - 1, new_amounts, robots])
          # seen[[minutes - 1, new_amounts, robots]] = true
          

          # ore += ore_collecting
          # clay += clay_collecting
          # obsidian += obsidian_collecting
          # geode += geode_collecting
        end

        total += (max * blueprint.first)
      end

      total
    end

    def part2(input)
      i2nput = "Blueprint 1: Each ore robot costs 4 ore. Each clay robot costs 2 ore. Each obsidian robot costs 3 ore and 14 clay. Each geode robot costs 2 ore and 7 obsidian.
Blueprint 2: Each ore robot costs 2 ore. Each clay robot costs 3 ore. Each obsidian robot costs 3 ore and 8 clay. Each geode robot costs 3 ore and 12 obsidian."
      input = input.strip.split("\n").map { |line| line.split(' ').map(&:to_i).reject(&:zero?) }

      input = input[0..2]

      # state = [ minutes_left, [ore, clay, obsidian, geode], [ore_collecting, clay_collecting, obsidian_collecting, geode_collecting], [robot_order]]
      #
      total = 1

      input.each.with_index do |blueprint, index|
        state = [32, [0, 0, 0, 0], [1, 0, 0, 0] ]
        max = 0
        queue = [state]

        puts blueprint.inspect

        costs = [
          [-blueprint[1], 0, 0, 0],
          [-blueprint[2], 0, 0, 0], 
          [-blueprint[3], -blueprint[4], 0, 0],
          [-blueprint[5], 0, -blueprint[6], 0]
        ]

        max_geodes = {}
        seen = {}

        until queue.empty?
          state = queue.shift
          minutes, amounts, robots = state
          max = [max, amounts.last].max

          #puts minutes
          next if minutes.zero?

          ore, clay, obsidian, geode = amounts
          ore_collecting, clay_collecting, obsidian_collecting, geode_collecting = robots

          #puts "min: #{minutes}, max: #{max}"

          max_geodes[minutes] ||= 0

          next if max_geodes[minutes] > geode

          max_geodes[minutes] = geode if geode > max_geodes[minutes]

          amounts_after_costs = costs.map do |cost|
            amounts.zip(cost).map(&:sum)
          end

          robot = false

          costs.each.with_index do |cost, i|
            c = amounts.zip(cost).map(&:sum)
            possible = c.none?(&:negative?)

            geode_possible = amounts_after_costs.last.none?(&:negative?)
            obsidian_possible = amounts_after_costs[2].none?(&:negative?)

            possible = false if geode_possible && i < 3
            possible = false if obsidian_possible && i < 2
            possible = false if i == 0 && ore_collecting >= -costs.map(&:first).min
            possible = false if i == 1 && clay_collecting >= -costs.map{ |c| c[1] }.min

            if possible
              #puts "JA" if i == 3
              robot = true
              new_amounts = c
              new_amounts = new_amounts.zip(robots).map(&:sum)
              new_robots = robots.dup
              new_robots[i] += 1

              # puts "amount_before #{amounts}"
              # puts "amount_after #{new_amounts}"
              # puts "robots #{robots}"
              # puts "c #{c}"
              # puts "--"
              # unless seen.key?(new_robots_order) && seen[new_robots_order.sort] > minutes
              unless seen.key?([minutes - 1, new_amounts, new_robots])
                queue.push([minutes - 1, new_amounts, new_robots])
              end
              seen[[minutes - 1, new_amounts, new_robots]] = true
              # seen[new_robots_order.sort] = minutes
            end
          end

          next if ore > minutes * -costs.map(&:first).min

          next if clay > minutes * -costs.map{ |c| c[1] }.min
          
          new_amounts = amounts.zip(robots).map(&:sum)
          queue.push([minutes - 1, new_amounts, robots]) unless seen.key?([minutes - 1, new_amounts, robots])
          # seen[[minutes - 1, new_amounts, robots]] = true
          

          # ore += ore_collecting
          # clay += clay_collecting
          # obsidian += obsidian_collecting
          # geode += geode_collecting
        end

        total *= max
      end

      total
    end
  end
end
