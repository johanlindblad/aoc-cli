require 'union_find'

module Year2023
  class Day25
    def part1(input)
      in2put = "jqt: rhn xhk nvd
rsh: frs pzl lsr
xhk: hfx
cmg: qnr nvd lhk bvb
rhn: xhk bvb hfx
bvb: xhk hfx
pzl: lsr hfx nvd
qnr: nvd
ntq: jqt hfx bvb xhk
nvd: lhk
lsr: lhk
rzs: qnr cmg lsr rsh
frs: qnr lhk lsr"
      vs = input.strip.split("\n").flat_map do |line|
        name, connected = line.split(": ")
        connected = connected.split(" ")

        connected.flat_map do |c|
          [[name, c].sort, [c, name].sort]
        end
      end.to_set

      len = vs.length

      cs = vs.to_a.combination(len - 3)

      cs.each do |c|
        nodes = c.flatten.to_set
        uf = UnionFind::UnionFind.new(nodes)

        c.each do |v|
          uf.union(*v)
        end

        if uf.count_isolated_components == 2
          return "JA"
        end
      end

    end

    def part2(input)
      nil
    end
  end
end
