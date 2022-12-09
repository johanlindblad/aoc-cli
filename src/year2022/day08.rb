module Year2022
  class Day08
    def part1(input)
      map = input.strip.split('\n').map { |row| row.split('').map(&:to_i) }
      width = map.first.length
      height = map.length

      visible = 1.upto(height - 2).flat_map do |row|
        1.upto(width - 2).map do |col|
          h = map[row][col]
          map[row][0...col].all? { |x| x < h } ||
            map[row][col + 1...width].all? { |x| x < h } ||
            (0...row).all? { |x| map[x][col] < h } ||
            (row + 1...height).all? { |x| map[x][col] < h }
        end
      end

      visible.select.count + (2 * height) + (2 * width) - 4
    end

    def part2(input)
      map = input.strip.split("\n").map { |row| row.split('').map(&:to_i) }
      width = map.first.length
      height = map.length

      cover = 0.upto(height - 1).flat_map do |row|
        0.upto(width - 1).map do |col|
          h = map[row][col]

          left = map[row][0...col].reverse.take_while { |x| x < h }.count if row.positive?
          right = map[row][col + 1...width].take_while { |x| x < h }.count if row < (width - 1)
          top = (0...row).map { |x| map[x][col] }.reverse.take_while { |x| x < h }.count if col.positive?
          bottom = (row + 1...height).map { |x| map[x][col] }.take_while { |x| x < h }.count if col < (height - 1)

          left += 1 unless left == col || left.nil?
          right += 1 unless right == (width - 1) - col || right.nil?
          top += 1 unless top == row || top.nil?
          bottom += 1 unless bottom == (height - 1) - row || bottom.nil?

          [left, right, top, bottom].reject(&:nil?).reduce(&:*)
        end
      end

      cover.max
    end
  end
end
