module Year2023
  class Day15
    def part1(input)
      inp2ut = "rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7"
      input = input.strip.split(",")

      input.map do |part|
        hash(part)
      end.sum
    end

    def hash(s)
      cur = 0

      s.chars.each do |c|
        cur += c.ord
        cur *= 17
        cur %= 256
      end

      cur
    end

    def part2(input)
      input2 = "rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7"
      input = input.strip.split(",")

      boxes = 0.upto(256).map do [] end

      input.each do |ins|
        parts = ins.split(/=|-/)
        label, number = parts
        number = number.to_i
        hash = hash(label)

        op = :remove
        op = :replace if ins.include? "="

        if op == :remove
          boxes[hash] = boxes[hash].reject { |lens| lens.first == label }
        else
          i = boxes[hash].find_index { |lens| lens.first == label }
          
          if i.nil?
            boxes[hash].push([label, number])
          else
            boxes[hash][i] = [label, number]
          end
        end
      end

      boxes.map.with_index do |contents, i|
        contents.map.with_index do |lens, j|
          l, n = lens
          (i + 1) * (j + 1) * n
        end.sum
      end.sum
    end
  end
end
