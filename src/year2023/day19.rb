module Year2023
  class Day19
    def part1(input)
      _input = "px{a<2006:qkq,m>2090:A,rfg}
        pv{a>1716:R,A}
        lnx{m>1548:A,A}
        rfg{s<537:gd,x>2440:R,A}
        qs{s>3448:A,lnx}
        qkq{x<1416:A,crn}
        crn{x>2662:A,R}
        in{s<1351:px,qqz}
        qqz{s>2770:qs,m<1801:hdj,R}
        gd{a>3333:R,R}
        hdj{m>838:A,pv}

        {x=787,m=2655,a=1222,s=2876}
        {x=1679,m=44,a=2067,s=496}
        {x=2036,m=264,a=79,s=2244}
        {x=2461,m=1339,a=466,s=291}
        {x=2127,m=1623,a=2188,s=1013}"

      workflows, parts = input.split("\n\n")

      workflows = parse_workflows(workflows)
      parts = parse_parts(parts)

      destinations = parts.map do |part|
        at = "in"

        loop do
          criteria = workflows[at]

          break if %w[A R].include?(at)

          criteria.each do |criterium|
            cond, target = criterium

            if cond.nil?
              at = target
              break
            else
              var, op, num = cond
              val = part[var]
              result = val.send(op, num)

              if result == true
                at = target
                break
              end
            end
          end
        end

        [part, at]
      end

      destinations.select { |d| d.last == "A" }.map(&:first).map do |part|
        part.values.sum
      end.sum
    end

    def part2(input)
      _input = "px{a<2006:qkq,m>2090:A,rfg}
        pv{a>1716:R,A}
        lnx{m>1548:A,A}
        rfg{s<537:gd,x>2440:R,A}
        qs{s>3448:A,lnx}
        qkq{x<1416:A,crn}
        crn{x>2662:A,R}
        in{s<1351:px,qqz}
        qqz{s>2770:qs,m<1801:hdj,R}
        gd{a>3333:R,R}
        hdj{m>838:A,pv}

        {x=787,m=2655,a=1222,s=2876}
        {x=1679,m=44,a=2067,s=496}
        {x=2036,m=264,a=79,s=2244}
        {x=2461,m=1339,a=466,s=291}
        {x=2127,m=1623,a=2188,s=1013}"

      workflows, _parts = input.split("\n\n")

      workflows = parse_workflows(workflows)

      queue = [["in", { "x" => 1..4000, "m" => 1..4000, "a" => 1..4000, "s" => 1..4000 }]]
      queue.inspect
      accepted = []

      until queue.empty?
        at, ranges = queue.pop
        next if at == "R"

        if at == "A"
          accepted.push(ranges)
          next
        end

        next if ranges.values.any? { |range| range.count == 0 }

        criteria = workflows[at]

        criteria.each do |criterium|
          cond, target = criterium

          if cond.nil?
            queue.push([target, ranges])
          else
            var, op, num = cond

            ranges2 = ranges.dup

            if op == :>
              ranges2[var] = (num + 1)..ranges2[var].last
              ranges[var] = ranges[var].first..num
            elsif op == :<
              ranges2[var] = ranges2[var].first..(num - 1)
              ranges[var] = num..ranges[var].last
            end

            queue.push([target, ranges2])
          end
        end
      end

      accepted.map do |ranges|
        ranges.values.map(&:count).reduce(&:*)
      end.sum

      # Rätt
      # 167_409_079_868_000
    end

    def parse_workflows(s)
      s.split("\n").map do |wf|
        name, rest = wf.strip.delete("}").split("{")

        criteria = rest.split(",").map do |criterium|
          cond, target = criterium.split(":")

          if target.nil?
            [nil, cond]
          else
            var = cond[0]
            op = cond[1].to_sym
            num = cond[2..].to_i
            [[var, op, num], target]
          end
        end

        [name, criteria]
      end.to_h
    end

    def parse_parts(s)
      s.split("\n").map do |line|
        line = line.strip.delete("{").delete("}").split(",")
        line.map do |chunk|
          k, v = chunk.split("=")
          [k, v.to_i]
        end.to_h
      end
    end

    def part2old(input)
      input = "px{a<2006:qkq,m>2090:A,rfg}
pv{a>1716:R,A}
lnx{m>1548:A,A}
rfg{s<537:gd,x>2440:R,A}
qs{s>3448:A,lnx}
qkq{x<1416:A,crn}
crn{x>2662:A,R}
in{s<1351:px,qqz}
qqz{s>2770:qs,m<1801:hdj,R}
gd{a>3333:R,R}
hdj{m>838:A,pv}

{x=787,m=2655,a=1222,s=2876}
{x=1679,m=44,a=2067,s=496}
{x=2036,m=264,a=79,s=2244}
{x=2461,m=1339,a=466,s=291}
{x=2127,m=1623,a=2188,s=1013}"

      workflows, = input.split("\n\n")

      workflows = workflows.split("\n").map do |line|
        name, code = line.delete("}").split("{")

        code = code.split(",").map do |part|
          cond, send = part.split(":")

          if send.nil?
            [nil, cond]
          else
            cat = cond[0]
            op = cond[1]
            num = cond[2..].to_i
            [[cat, op, num], send]
          end
        end

        [name, code]
      end
      workflows = Hash[workflows]

      parts = [[{ "x" => 1..4000, "m" => 1..4000, "a" => 1..4000, "s" => 1..4000 }, "in"]]

      loop do
        before = parts.dup
        parts = parts.flat_map { solve2(_1, workflows) }

        next unless parts == before

        accepted = parts.select do |part|
          part.last == "A"
        end.map(&:first)

        return accepted.map do |hash|
          hash.values.map(&:size).reduce(&:*)
        end.sum
      end
    end

    def solve2(part, workflows)
      puts part.inspect
      puts "--"
      part, rule = part

      return [[part, rule]] if %w[A R].include?(rule)

      backlog = []

      steps = workflows[rule]

      res = nil

      steps.each do |step|
        code, res = step
        key, op, num = code

        if op == "<" && (part[key].last >= num)
          # Need to split
          before = (part[key].first)...num
          after = num..(part[key].last)

          obefore = part
          obefore[key] = before
          oafter = part
          oafter[key] = after

          part = oafter
          backlog.push([obefore, res])
        end
        next unless op == ">"

        next unless part[key].first > num

        # Need to split
        before = (part[key].first)..num
        after = num...(part[key].last)

        obefore = part
        obefore[key] = before
        oafter = part
        oafter[key] = after

        part = obefore
        backlog.push([oafter, res])
      end

      [[part, res]] + backlog
    end
  end
end
