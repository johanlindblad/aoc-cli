module Year2023
  class Day12
    def part1(input)
      input = "???.### 1,1,3
.??..??...?##. 1,1,3
?#?#?#?#?#?#?#? 1,3,1,6
????.#...#... 4,1,1
????.######..#####. 1,6,5
?###???????? 3,2,1"
      rows = input.strip.split("\n").map do |line|
        arrangement, groups = line.split(" ")
        arrangement = arrangement.split(".").reject(&:empty?)
        groups = groups.split(",").map(&:to_i)
        [arrangement, groups]
      end

      rows.map do |row|
        a, g = row
        #run(a, g, {})
        ways(a, g)
      end.inspect
      #ways(rows[0].first, rows[0].last)
      #ways(["??", "###"], [1,1,3])
      #ways(["?#?"], [2])
      #ways(["#?"], [2])
      #ways(["?#?#"], [1,1])
      #ways(["?#"], [1])
    end

    # IF len is one, need an extra space after #
    # otherwise no
    def ways(from_input, groups, cache={})
      #puts from_input.inspect
      #puts groups.inspect
      puts ["call ways", from_input, groups].inspect

      if from_input.empty? && !groups.empty?
        return 0
      end

      if groups.empty?
        return 1 if from_input.none? { |c| c == "#" }
        return 0
      end

      if from_input.first.empty?
        return ways(from_input[1..], groups, cache)
      end

      unless cache.has_key? [from_input, groups]
        len = groups.first
        input = from_input.first
        char = input.chars.first
        value = 0

        if input.length < len && 1 == 2
          value = ways(from_input[1..], groups, cache) if input.chars.all? { |c| c == "?"}
        else
          # Setting "#" - making room for extra
          #puts "Set #"
          #value += ways([input[(1 + len)..]] + from_input[(len + 1)..], groups[1..], cache) if input.length < len
          #if char == "#"
          # Simlate setting "#"
          #
          if len == 1
            rest_input = from_input[1..]
            rest_input = [input[2..]] + rest_input if input.length > 1
            #rest_input = [input[2..]] + rest_input if input.length > 1 && input[1] == "#"
            rest_groups = groups[1..]
            value += ways(rest_input, rest_groups, cache)# if input.length > 2
          else
            rest_input = from_input[1..]
            rest_input = [input[1..]] + rest_input if input.length > 1
            rest_groups = [len - 1] + groups[1..]
            value += ways(rest_input, rest_groups, cache) if input.length > 1
          end
          #end

          # Simulate setting "."
          if char == "?" && input.length > 1
            rest_input = [input[1..]] + from_input[1..]
            rest_groups = groups
            value += ways(rest_input, rest_groups, cache) 
          end

          # Setting "."
          #if char != "#"
          #rest_input = from_input[1..]
          #rest_input = [input[1..]] + rest_input if input.length > 1
          #rest_groups = groups[1..]
          #rest_groups = [len] + rest_groups if len > 1
          #value += ways(rest_input, rest_groups, cache) 
          #end
          #puts "Set ."
          #puts "input[1..]: ", [input[1..]].inspect
          #puts "from_input[1..]: ", from_input[1..].inspect
          #value += ways([input[1..]] + from_input[1..], groups, cache) if input.length >= len
          #value += ways([input[1..]] + from_input[1..], groups, cache) if char != "#"
        end

        cache[[from_input, groups]] = value
      end

      puts ["ways", from_input, groups].inspect
      puts ["res ", cache[[from_input, groups]]].inspect
      cache[[from_input, groups]]
    end

    def run(a, g, cache)
      i = a.index("?")
      #puts "RUN(#{a.inspect}, #{g.inspect})"

      if i.nil?
        if a.split(".").reject(&:empty?).map(&:length) == g
          1
        else
          0
        end
      else
        num = i.upto(a.length - 1).take_while { |j| a[j] == "?" }.length

        a1 = a.dup
        a1[i] = "#"
        a2 = a.dup
        a2[i] = "."
        run(a1, g, cache) + run(a2, g, cache)
      end
    end

    def num_ways(a, g, acc=1)
      i = a.index("?")

      if i.nil?
        return acc
      end



    end

    def part2(input)
      input2 = "???.### 1,1,3
.??..??...?##. 1,1,3
?#?#?#?#?#?#?#? 1,3,1,6
????.#...#... 4,1,1
????.######..#####. 1,6,5
?###???????? 3,2,1"
      rows = input.strip.split("\n").map do |line|
        arrangement, groups = line.split(" ")
        arrangement = (arrangement + "?") * 5
        arrangement = arrangement[0...-1]
        groups = groups.split(",").map(&:to_i) * 5
        [arrangement + ".", groups]
      end

      rows.map do |row|
        a, g = row

        indices = 0.upto(a.length - 1).select { |i| a[i] == "?" }

        state = 0.upto(a.length + 1).map do
          0.upto(g.length + 2).map do
            0.upto(a.length + 2).map do
              0
            end
          end
        end
        state[0][0][0] = 1

        0.upto(a.length).each do |i|
          0.upto(g.length + 1).each do |j|
            0.upto(a.length + 1).each do |p|
              if state[i][j][p] > 0
                cur = state[i][j][p]
                if a[i] == "." || a[i] == "?"
                  if p == 0 || p == g[j - 1]
                    state[i+1][j][0] += cur
                  end
                end

                if a[i] == "#" || a[i] == "?"
                  pp = p == 0 ? 1 : 0
                  state[i+1][j + pp][p + 1] += cur
                end
              end

            end
          end
        end

        puts state[a.length][g.length][0].inspect
        state[a.length][g.length][0]


      end.sum
    end
  end
end
