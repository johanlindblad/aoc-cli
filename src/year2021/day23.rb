require 'pqueue'

module Year2021
  class Day23
    HALLWAY_XS = [0, 1, 3, 5, 7, 9, 10].freeze
    ROOM_XS = [2, 4, 6, 8].freeze
    TARGET_XS = { A: 2, B: 4, C: 6, D: 8 }.freeze
    COST = { A: 1, B: 10, C: 100, D: 1000 }.freeze

    def part1(input)
      room_height = 2

      if true
        input = input.split("\n")
        input.insert(3, '  #D#C#B#A#')
        input.insert(4, '  #D#B#A#C#')
        input = input.join("\n")
        room_height = 4
      end

      rooms = input.scan(/\w/).each_slice(4).to_a.transpose
      rooms = rooms.map.with_index do |letters, index|
        letters.reverse.reduce([]) do |acc, letter|
          letter = letter.to_sym
          lock = letter == %i[A B C D][index] && acc.all?(&:last)
          acc + [[letter, lock]]
        end.reverse
      end

      queue = PQueue.new { |a, b| a.heuristic < b.heuristic }
      queue.push(State.new(0, {}, rooms))

      random = (0..1000).to_a

      min_energy = {}

      until queue.empty?
        state = queue.pop

        return state.energy if state.finished?

        puts state.energy if random.sample == 0

        state.movable_rooms.each do |pair|
          pair, index = pair
          letter, _locked = pair
          x = ROOM_XS[index]

          left = HALLWAY_XS.select { |nx| nx < x }.reverse.take_while { |nx| !state.hallway.key?(nx) }.reverse
          right = HALLWAY_XS.select { |nx| nx > x }.take_while { |nx| !state.hallway.key?(nx) }
          possibilities = left + right

          possibilities.each do |possibility|
            y_steps = room_height + 1 - state.rooms[index].length
            x_steps = (possibility - x).abs
            extra_steps = y_steps + x_steps
            extra_energy = COST[letter] * extra_steps
            # puts "#{y_steps} up and #{x_steps} side to get to #{possibility} from #{x} for #{letter}"

            new_rooms = state.rooms.map(&:dup)
            new_rooms[index].shift

            new_energy = state.energy + extra_energy

            new_state = State.new(
              new_energy,
              state.hallway.merge({ possibility => letter }),
              new_rooms
            )

            unless min_energy.key?(new_state.key) && min_energy[new_state.key] <= new_energy
              queue.push(new_state)
              min_energy[new_state.key] = new_energy
            end
          end
        end

        state.moveable_hallway.each do |x, letter|
          target_x = TARGET_XS[letter]
          passing = x > target_x ? (target_x..x) : (x..target_x)
          blocked = (passing.to_a & state.hallway.keys).length > 1
          next if blocked

          index = %i[A B C D].index(letter)
          y_steps = room_height - state.rooms[index].length
          x_steps = (target_x - x).abs
          extra_steps = y_steps + x_steps
          extra_energy = COST[letter] * extra_steps

          new_rooms = state.rooms.map(&:dup)
          new_rooms[index].unshift([letter, true])

          new_energy = state.energy + extra_energy

          new_state = State.new(
            new_energy,
            state.hallway.except(x),
            new_rooms
          )

          unless min_energy.key?(new_state.key) && min_energy[new_state.key] <= new_energy
            queue.push(new_state)
            min_energy[new_state.key] = new_energy
          end
        end
      end
    end

    State = Struct.new(:energy, :hallway, :rooms) do
      def movable_rooms
        rooms.map.with_index { |s, i| [s.first, i] }.reject do |pair|
          room, _index = pair
          _letter, locked = room
          room.nil? || locked
        end
      end

      def moveable_hallway
        hallway.select do |_x, letter|
          target_index = %i[A B C D].index(letter)
          rooms[target_index].all? { |pair| pair.last == true } # All in room need to be locked
        end
      end

      def finished?
        hallway.empty? && rooms.all? do |letters|
          letters.map(&:last).all?
        end
      end

      def heuristic
        energy
      end

      def key
        [hallway, rooms]
      end
    end

    def part2(_input)
      nil
    end
  end
end
