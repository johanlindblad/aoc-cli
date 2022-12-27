module Year2022
  class Day21
    def part1(input)
      input = input.strip.split("\n").map do |line|
        line.split(': ')
      end

      answers = {}

      target = 'root'

      until answers.key?(target)
        i = 0

        while i < input.length
          name, data = input[i]

          if data.split(' ').length == 1
            answers[name] = data.to_i
            input.delete_at(i)
          else
            operators = ['+', '-', '*', '/']

            operators.each do |op|
              next unless data.include?(op)

              parts = data.split(" #{op} ")

              if parts.all? { |name| answers.key?(name) }
                answers[name] = answers[parts[0]].send(op.to_sym, answers[parts[1]])
              end
            end
            
            if answers.key?(name)
              input.delete_at(i)
            else
              i += 1
            end
          end
        end
      end

      answers[target]
    end

    def val(humn, input, target)
      input = input.dup
      humn_i = input.find_index { |m| m.first == 'humn' }
      input[humn_i] = ['humn', humn.to_s]
      answers = {}

      until answers.key?(target)
        i = 0

        while i < input.length
          name, data = input[i]

          if data.split(' ').length == 1
            answers[name] = data.to_i
            input.delete_at(i)
          else
            operators = ['+', '-', '*', '/']

            operators.each do |op|
              if data.include?(op)
                parts = data.split(" #{op} ")

                if parts.all? { |name| answers.key?(name) }
                  answers[name] = answers[parts[0]].send(op.to_sym, answers[parts[1]])
                end
              end
            end

            if answers.key?(name)
              input.delete_at(i)
            else
              i += 1
            end
          end
        end
      end

      answers[target]
    end

    def part2(input)
      input = input.strip.split("\n").map do |line|
        line.split(': ')
      end

      answers = {}

      root_i = input.find_index { |m| m.first == 'root' }

      both = input[root_i].last.split(' + ')
      input.delete_at(root_i)

      loop do
        i = 0
        before = answers.length

        while i < input.length
          name, data = input[i]

          if name == 'humn'
            i += 1
            next
          end

          if data.split(' ').length == 1
            answers[name] = data.to_i
            input.delete_at(i)
          else
            operators = ['+', '-', '*', '/']

            operators.each do |op|
              next unless data.include?(op)
              parts = data.split(" #{op} ")

              if parts.all? { |name| answers.key?(name) }
                answers[name] = answers[parts[0]].send(op.to_sym, answers[parts[1]])
              end
            end
            
            if answers.key?(name)
              input.delete_at(i)
            else
              i += 1
            end
          end
        end

        break if answers.length == before
      end

      input.map! do |i|
        name, data = i

        parts = data.split(' ')

        if answers.key?(parts[0])
          parts[0] = answers[parts[0]]
        end

        if answers.key?(parts[2])
          parts[2] = answers[parts[2]]
        end

        [name, parts]
      end

      change = true

      while change
        change = false

        input.each.with_index do |i, index|
          next if i.first == 'humn'

          name, data = i

          if data[0].is_a?(String) && data[0] != 'humn'
            fi = input.find_index { |j| j.first == data[0] }
            data[0] = input[fi].last
            input[index] = [name, data]
            change = true
          end

          if data[2].is_a?(String) && data[2] != 'humn'
            fi = input.find_index { |j| j.first == data[2] }
            data[2] = input[fi].last
            input[index] = [name, data]
            change = true
          end
        end
      end

      target = nil
      formula = nil

      both.each do |key|
        if answers.key?(key)
          target = answers[key]
        else
          k = input.find { |i| i.first == key }
          formula = k.last
        end
      end

      loop do
        break if formula == 'humn'
        
        if formula.last.is_a?(Integer)
          op = formula[1]

          case op
          when '+'
            target -= formula.last
            formula = formula.first
          when '-'
            target += formula.last
            formula = formula.first
          when '*'
            target /= formula.last
            formula = formula.first
          when '/'
            target *= formula.last
            formula = formula.first
          end
        elsif formula.first.is_a?(Integer)
          op = formula[1]

          case op
          when '+'
            target -= formula.first
            formula = formula.last
          when '-'
            target = formula.first - target
            formula = formula.last
          when '*'
            target /= formula.first
            formula = formula.last
          when '/'
            target = formula.first / target
            formula = formula.last
          end
        else
          break
        end
      end
      
      target
    end
  end
end
