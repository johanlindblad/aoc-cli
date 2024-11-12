module Year2023
  Brick = Struct.new(:x, :y, :z, :name, :rests_on) do
    def xy
      @xy ||= x.to_a.product(y.to_a)
    end

    def reset
      @xy = nil
    end

    def xz_coordinates
      x.to_a.product(z.to_a, [y.first], [name])
    end
  end

  class Day22
    def part1(input)
      _input = "1,0,1~1,2,1
0,0,2~2,0,2
0,2,3~2,2,3
0,0,4~0,2,4
2,0,5~2,2,5
0,1,6~2,1,6
1,1,8~1,1,9"

      letters = (:A..:Z).to_a
      numbers = (1..1_000_000).to_a

      bricks = input.split("\n").map do |line|
        cs = line.split(/,|~/).map(&:to_i)
        xs = [cs[0], cs[3]].sort
        ys = [cs[1], cs[4]].sort
        zs = [cs[2], cs[5]].sort
        Brick.new(Range.new(*xs), Range.new(*ys), Range.new(*zs), letters.shift || numbers.shift, Set.new)
      end.sort_by { |b| b.z.first }

      height_map = {}
      settled_bricks = []

      bricks.each do |brick|
        lands_on = brick.xy.map { |xy| height_map[xy] }.reject(&:nil?)
        highest = lands_on.map(&:first).max || 0
        lands_on = lands_on.select { |pair| pair.first == highest }.map(&:last).uniq

        diff = brick.z.first - highest - 1
        brick.z = Range.new(brick.z.first - diff, brick.z.last - diff)
        brick.xy.each { |xy| height_map[xy] = [brick.z.max, brick.name] }
        brick.rests_on = lands_on
        settled_bricks.push(brick)
      end

      required = bricks.select { |b| b.rests_on.length == 1 }.map(&:rests_on).uniq
      bricks.length - required.length
    end

    def part2(input)
      _input = "1,0,1~1,2,1
0,0,2~2,0,2
0,2,3~2,2,3
0,0,4~0,2,4
2,0,5~2,2,5
0,1,6~2,1,6
1,1,8~1,1,9"

      letters = (:A..:Z).to_a
      numbers = (1..1_000_000).to_a

      bricks = input.split("\n").map do |line|
        cs = line.split(/,|~/).map(&:to_i)
        xs = [cs[0], cs[3]].sort
        ys = [cs[1], cs[4]].sort
        zs = [cs[2], cs[5]].sort
        Brick.new(Range.new(*xs), Range.new(*ys), Range.new(*zs), letters.shift || numbers.shift, Set.new)
      end.sort_by { |b| b.z.first }

      height_map = {}
      settled_bricks = []

      bricks.each do |brick|
        lands_on = brick.xy.map { |xy| height_map[xy] }.reject(&:nil?)
        highest = lands_on.map(&:first).max || 0
        lands_on = lands_on.select { |pair| pair.first == highest }.map(&:last).uniq

        diff = brick.z.first - highest - 1
        brick.z = Range.new(brick.z.first - diff, brick.z.last - diff)
        brick.xy.each { |xy| height_map[xy] = [brick.z.max, brick.name] }
        brick.rests_on = Set.new(lands_on)
        settled_bricks.push(brick)
      end

      graph = {}
      bricks.each do |brick|
        brick.rests_on.each do |other_name|
          graph[other_name] ||= Set.new
          graph[other_name].add(brick.name)
        end
      end

      cascade_count = graph.keys.map do |name|
        removed = Set.new([name])
        # puts "IF REMOVE #{name}"

        loop do
          changed = false

          bricks.each do |brick|
            next if removed.include?(brick.name)
            next if brick.rests_on.empty?
            next unless (brick.rests_on - removed).empty?

            removed.add(brick.name)
            changed = true
            # puts "ALSO REMOVES #{brick.name}"
          end

          break unless changed
        end

        removed.count - 1
      end

      cascade_count.sum
    end

    def print(bricks)
      projection = bricks.flat_map(&:xz_coordinates).group_by do |ba|
        ba.first(2)
      end.transform_values do |a|
        if a.length > 1
          "?"
        else
          a.first.last
        end
      end

      xs = Range.new(*projection.keys.map(&:first).minmax)
      ys = Range.new(*projection.keys.map(&:last).minmax)

      puts xs.inspect
      puts ys.inspect

      puts xs.to_a.map(&:to_s).join("")

      ys.to_a.reverse.each do |y|
        puts xs.map { |x| projection[[x, y]] || "." }.join("")
      end
    end
  end
end
