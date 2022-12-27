module Year2022
  class Day22
    # https://old.reddit.com/r/adventofcode/comments/zsct8w/2022_day_22_solutions/j1brkv2/
    def part2(input)
      map, path = input.split("\n\n")
      map = map.split("\n").map(&:chars)
      path = path.scan(/([0-9]+)(R|L)?/).map { |p| [p[0].to_i, p[1]] }

      square_length = Math.sqrt(((input.count('.') + input.count('#')) / 6)).round
      board_state = map
      valid_squares = 0.upto(board_state.length - 1).flat_map do |i|
        0.upto(board_state[i].length - 1).reject { |j| board_state[i][j] == ' ' }.map do |j|
          [i / square_length, j / square_length]
        end
      end.uniq

      board_state = valid_squares.map do |square|
        x, y = square

        val = 0.upto(square_length - 1).map do |i|
          0.upto(square_length - 1).map do |j|
            board_state[x * square_length + i][y * square_length + j]
          end
        end

        [[x, y], val]
      end.to_h

      square_links = valid_squares.map do |anchor|
        [anchor, get_cube_neighbours(fold_cube(valid_squares, anchor))]
      end.to_h

      board = Board.new(square_links, square_length, board_state)

      path.each do |part|
        steps, rotate = part

        steps.times do
          moved = board.move
          break unless moved
        end

        board.rotate(rotate) unless rotate.nil?
      end

      board_x, board_y = board.board
      x, y = board.coords
      x = board_x * board.square_length + x + 1
      y = board_y * board.square_length + y + 1

      direction = %w[R D L U].index(board.direction)

      1000 * x + 4 * y + direction
    end

    def cross(vec1, vec2)
      x1, y1, z1 = vec1
      x2, y2, z2 = vec2
      x = y1 * z2 - z1 * y2
      y = z1 * x2 - x1 * z2
      z = x1 * y2 - y1 * x2
      [x, y, z]
    end

    def rotate_3d(plane_axis, vector, num)
      # rotates the vector by 90 degrees * n ccw. Assume plane_axis is pointing into the plane.
      num.times do
        vector = cross(vector, plane_axis)
      end

      vector
    end

    def fold_cube(valid_squares, anchor)
      # anchor square has centre [0,0,-1] (-z) with net_right pointing to [0,1,0] (+y)
      cubes = { anchor => [[0,0,-1], [0,1,0]] }

      remaining = valid_squares.reject { |sq| sq == anchor }

      until remaining.empty?
        new_cubes = {}

        remaining.each do |remaining_square|
          cubes.each do |square, value|
            centre, net_right = value

            difference = remaining_square.zip(square).map do |pair|
              i, j = pair
              i - j
            end

            next unless [[0, 1], [-1, 0], [0, -1], [1, 0]].include?(difference)

            # turn_offsets from Right. 1 is Up, 2 is Left, 3 is Down.
            turn_offset = [[0, 1], [-1, 0], [0, -1], [1, 0]].index(difference)

            new_centre = rotate_3d(centre, net_right, turn_offset)
            new_net_right = rotate_3d(new_centre, centre, (2 - turn_offset) % 4)
            new_cubes[remaining_square] = [new_centre, new_net_right]
          end
        end

        cubes.merge!(new_cubes)
        remaining = remaining.reject { |sq| cubes.include?(sq) }
      end

      cubes
    end

    # gets neighbours of the cube at -z with associated turn.
    def get_cube_neighbours(cubes)
      inverse_cubes = cubes.map do |square, value|
        centre, net_right = value

        [centre, [square, net_right]]
      end.to_h

      output = {}

      [[0, 1], [-1, 0], [0, -1], [1, 0]].each.with_index do |direction, turn_offset|
        plane_axis = direction + [0]
        square, net_right = inverse_cubes[plane_axis]
        hyp_right = rotate_3d(plane_axis, [0, 0, 1], (-turn_offset) % 4)

        count = 0

        while hyp_right != net_right
          count += 1
          hyp_right = rotate_3d(plane_axis, hyp_right, 1)
        end

        key = 'RULD'[turn_offset]
        rotate_offset = 'NRTL'[count]
        output[key] = [square, rotate_offset]
      end

      output
    end

    Board = Struct.new(:square_links, :square_length, :board_state, :direction, :board, :coords) do
      def initialize(square_links, square_length, board_state, direction='R', board=nil)
        super
        self.board = square_links.keys.min
        self.coords = [0, board_state[self.board][0].index('.')]
      end

      def move
        direction = { 'R' => [0, 1], 'U' => [-1, 0], 'L' => [0, -1], 'D' => [1, 0] }[self.direction]
        try_x, try_y = self.coords.zip(direction).map(&:sum)

        if (0...square_length).include?(try_x) && (0...square_length).include?(try_y)
          if board_state[board][try_x][try_y] == '.'
            self.coords = [try_x, try_y]
            true
          else
            false
          end
        else
          try_board, turn = square_links[board][self.direction]
          try_x, try_y = [try_x, try_y].map { |num| num % square_length }
          try_x, try_y = rotate_board([try_x, try_y], square_length, turn)
          try_direction = turn_direction(self.direction, turn)

          if board_state[try_board][try_x][try_y] == '.'
            self.coords = [try_x, try_y]
            self.board = try_board
            self.direction = try_direction
            true
          else
            false
          end
        end
      end

      def rotate(turn)
        self.direction = turn_direction(self.direction, turn)
      end

      def rotate_board(coords, square_length, turn)
        # outputs the end coords given the intial coords and a turn to rotate - N L T or R
        x, y = coords
        num_left_turns = 'NLTR'.index(turn)

        0.upto(num_left_turns - 1) do
          x, y = [square_length - 1 - y, x]
        end

        [x, y]
      end

      # direction can be R U L D. turn is L R N T.
      def turn_direction(direction, turn)
        left_turn_order = 'RULD'
        num_left_turns = 'NLTR'.index(turn)
        new_index = (left_turn_order.index(direction) + num_left_turns) % 4
        return left_turn_order[new_index]
      end
    end
    
    def part1(input)
      map, path = input.split("\n\n")
      map = map.split("\n").map(&:chars)

      hash = {}

      map.each.with_index do |row, y|
        row.each.with_index do |c, x|
          if c != ' '
            hash[[y, x]] = c
          end
        end
      end

      visited = hash.dup

      path = path.scan(/([0-9]+)(R|L)?/).map { |p| [p[0].to_i, p[1]] }

      facing = [0, 1]
      position = [0, map[0].find_index { |c| c != ' ' }]

      path.each do |part|
        steps, rotation = part

        position = move(hash, position, facing, steps)
        facing = rotate(facing, rotation) unless rotation.nil?

        visited[position] = 'o'
      end

      row, col = position

      (1000 * (1 + row)) + (4 * (1 + col)) + facing_i(facing)
    end

    def move(hash, position, facing, steps)
      return position if steps == 0

      y, x = position
      dy, dx = facing

      min_y, max_y = hash.keys.select { |pair| pair.last == x }.map(&:first).minmax
      min_x, max_x = hash.keys.select { |pair| pair.first == y }.map(&:last).minmax

      y += dy
      x += dx

      y = min_y if dy > 0 && y > max_y
      y = max_y if dy < 0 && y < min_y

      x = min_x if dx > 0 && x > max_x
      x = max_x if dx < 0 && x < min_x

      if hash[[y, x]] != '.'
        return position
      else
        return move(hash, [y, x], facing, steps - 1)
      end
    end

    def rotate(facing, rotation)
      return [1, 0] if facing == [0, 1] && rotation == 'R'
      return [-1, 0] if facing == [0, 1] && rotation == 'L'

      return [-1, 0] if facing == [0, -1] && rotation == 'R'
      return [1, 0] if facing == [0, -1] && rotation == 'L'

      return [0, -1] if facing == [1, 0] && rotation == 'R'
      return [0, 1] if facing == [1, 0] && rotation == 'L'

      return [0, 1] if facing == [-1, 0] && rotation == 'R'
      return [0, -1] if facing == [-1, 0] && rotation == 'L'

      raise 'wtf'
    end

    def facing_i(facing)
      return 0 if facing == [0, 1]
      return 1 if facing == [1, 0]
      return 2 if facing == [0, -1]
      return 3 if facing == [-1, 0]
    end
  end
end
