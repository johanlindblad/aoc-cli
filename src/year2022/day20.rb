module Year2022
  class Day20
    def part1(input)
      input2 = "1
2
-3
3
-2
0
4"
      input = input.strip.split("\n").map(&:to_i).map.with_index{|v,i| [v,i]}

      original = input.dup

      original.each do |pair|
        number, index = pair
        current_index = input.index(pair)
        input.delete_at(current_index)
        target_index = (current_index + number) % input.length
        target_index = input.length if target_index == 0

        if false
          puts input.inspect
          puts number.inspect
          puts current_index
          puts target_index
          puts "-"
        end
      #puts input.inspect if input.length < 1000

        input.insert(target_index, pair)
      end

      input = input.map(&:first)
      zero = input.index(0)

      [input[(1000 + zero) % input.length], input[(2000 + zero) % input.length], input[(3000 + zero) % input.length]].sum
    end

    def part2(input)
      input2 = "1
2
-3
3
-2
0
4"
      input = input.strip.split("\n").map(&:to_i).map.with_index{|v,i| [v,i]}
      input = input.map { |pair| pair[0] *= 811589153;pair }

      original = input.dup

      10.times do
        original.each do |pair|
          number, index = pair
          current_index = input.index(pair)
          input.delete_at(current_index)
          target_index = (current_index + number) % input.length
          target_index = input.length if target_index == 0

          if false
            puts input.inspect
            puts number.inspect
            puts current_index
            puts target_index
            puts "-"
          end
        #puts input.inspect if input.length < 1000

          input.insert(target_index, pair)
        end
      end

      input = input.map(&:first)
      zero = input.index(0)

      [input[(1000 + zero) % input.length], input[(2000 + zero) % input.length], input[(3000 + zero) % input.length]].sum
    end
  end
end
