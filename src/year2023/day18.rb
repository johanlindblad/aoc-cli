module Year2023
  class Day18
    def part1(input)
      plan = input.split("\n").map do |line|
        dir, amount, _color = line.split(" ")
        [dir, amount.to_i]
      end

      solve(plan)
    end

    def part2(input)
      plan = input.split("\n").map do |line|
        _dir, _amount, hex = line.split(" ")

        hex = hex.delete("#()")

        amount = hex[0..4].to_i(16)
        dir = ["R", "D", "L", "U"][hex[5].to_i]
        [dir, amount]
      end

      solve(plan)
    end

    # https://topaz.github.io/paste/#XQAAAQD7CAAAAAAAAAARiEJGPfQWNG6xo4rUnrU/FzgTXmJOWQF53DaV6F4jcQsDsZs/mYVTr44+AFCZFK9N872JzIUYNTgDVGCWt9ctiBMzpBn9FYIqyIN8val2yqAr0ohWRwadd+RHWMHdft5hAEsE76y0MDNIDMbsknHYlx8pEqawmiFR7NJYrWW29CoRDoOB/lEW54tfmyehuRvoA/Xzc40pL0NAQT8wEDIAEErRtRh3GCLcrMo/HUITQD58M+uPbsZ+JHy/kckDI18UIc+ZlSpm0B9RTSKQ/5ZqYRhm7CAL2jyDf/4Z718QMHx9JzRHmS2im2TW+wqTvIP0UPLsOo07D3RBQL4EZVU9Mu0lxo0LIqmf5AHDJZGeEZBhBy5Lq68X1VgoJPiITiVzVrXkC8si8PyfDcdUhrzE1+azn7pFP6OEH+zPjr4Sf2oo+qtZfwQCjI1uA/Q3Plg70rh8AiMuoh90t8CFjv+CB5pkRhC+LohHYKvL+ejdw/GNlnob0EpKK1RV80LhrCmo/emv0Jvl8y684XFo/m4mlHh9yggRAAALfyu2Wfgp1Cld2zJnaUBHvhrZEiAx/GgQi31ld2yRVokESAYXEEjao527ceVCLsZOoquoEEXV9in7Oioz47z6UbBXx86MV0N8Jfs8zA5huT6ybJ9Ud5mZMbtb59nZ4dkwjeuJ8P4JZSUicvZKLqm2583HiZsB48Qdy6KZsjWB6cxui4Q0D+AXfOjCOLUggoG67MveD9yIHpdmfgSRlNCckKyh6NlahNsGrNkd4BXJzSlPO6aRJep06BNZ9WQZppAFNYK4aLF6idu6M6gI5qDdvbMzDsRiF2J1D2p5rBL2IBwKmEU3TIFe8wZtt+1NhWxmaqYK5BziKbIegKnQNlx5K4d0WTgZuWkf/s5oTQ==
    def solve(plan)
      grid = {[0, 0] => true}
      edges = Set.new
      answer = 0

      current = [0, 0]

      plan.each do |step|
        dir, amount = step
        prev = current

        case dir
        when "R"
          current = [current.first, current.last + amount]
        when "L"
          current = [current.first, current.last - amount]
        when "U"
          current = [current.first - amount, current.last]
        when "D"
          current = [current.first + amount, current.last]
        end

        edges.add([prev, current])
        answer += amount
      end

      edges.add([current, [0, 0]])

      area = 0.0

      # Shoelace formula
      edges.each do |edge|
        a, b = edge

        area += (a.last.to_f * b.first.to_f) - (a.first.to_f * b.last.to_f)
      end

      area = (area.abs / 2).to_i

      # Pick's theorem
      square_area = (area - (answer.to_f / 2) + 1).abs.to_i
      
      answer + square_area
    end
  end
end
