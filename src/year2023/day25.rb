require 'networkr'
require 'pqueue'
require 'pairing_heap'
require 'union_find'

module Year2023
  class Day25
    class Graph
      attr_accessor :adj_matrix, :vertices, :edges, :weights, :names

      def initialize
        @edges = {}
        @weights = {}
        @names = {}
      end

      def add_edge(u, v, weight)
        edges[u] ||= []
        edges[v] ||= []
        weights[[u, v]] = weight
        weights[[v, u]] = weight
        edges[u].push(v)
        edges[v].push(u)
        names[u] = u
        names[v] = v
      end

      def to_graphviz
        "graph G {" +
          edges.flat_map { |v, us|
            us.map { |u|
              [names[v], names[u]]
            }
          }.map { |pair| pair.sort.map(&:inspect).join("--") }.uniq.join(";\n") +
          "}"
      end

      def stoer_wagner
        min_cut = Float::INFINITY
        best_partition = nil
        remaining = edges.keys.to_set
        groups = remaining.map { |v| [v, [v].to_set] }.to_h # Initialize each vertex as its own group
        # puts to_graphviz
        union_find = UnionFind::UnionFind.new(remaining)

        while remaining.size > 1
          puts remaining.size
          # Phase of the algorithm
          a, w = minimum_cut_phase(remaining)

          # Update minimum cut and track the partition
          if w < min_cut
            min_cut = w
            # Partition groups: A = all except the last vertex in A; B = remaining - A
            last = a.last
            best_partition = [groups[last], edges.keys.to_set - groups[last]]
            # best_partition = [groups[last], remaining - groups[last]] <----- why?
            c1 = union_find.instance_variable_get("@parent").keys
            c2 = edges.keys - c1
            puts [c1, c2].inspect
            # best_partition = [c1, c2]
          end

          # Merge the last two vertices in A
          s = a[-2]
          t = a[-1]

          merge_vertices(remaining, s, t, groups, union_find)
        end

        [min_cut, best_partition]
      end

      private

      def minimum_cut_phase(remaining)
        n = remaining.size
        a = [remaining.first]
        visited = Set.new
        visited.add(remaining.first)
        heap = PairingHeap::MaxPriorityQueue.new

        max_weight = 0

        (1...n).each do
          last = a.last

          remaining.each do |v|
            next if visited.include?(v) || !weights.key?([last, v])

            if heap.include?(v)
              existing = heap.get_priority(v)

              heap.change_priority(v, existing + @weights[[last, v]])
              # puts "Updating #{v} to priority #{existing + @weights[[last, v]]}"
            else
              heap.push(v, @weights[[last, v]])
              # puts "Pushing #{v} with priority #{@weights[[last, v]]}"
            end
          end

          next_vertex = nil
          max_weight = 0

          next_vertex, max = heap.pop_with_priority
          max_weight = [max_weight, max].max

          a << next_vertex
          a = a.last(2) if a.length > 10
          visited.add(next_vertex)
        end

        [a, max_weight]
      end

      def merge_vertices(remaining, s, t, groups, union_find)
        union_find.union(s, t)
        remaining.delete(t)

        edges.each_key do |v|
          next if v == s
          next unless edges[v].include?(t)

          edges[v].delete(t)
          edges[v].push(s)
          edges[s].push(v)
          weights[[s, v]] ||= 0
          weights[[v, s]] ||= 0
          weights[[s, v]] += weights[[t, v]]
          weights[[v, s]] += weights[[t, v]]
        end

        # edges[t].each do |other|
        ## puts "#{t} and #{other}"
        # edges[other]&.delete(t)
        # end
        # edges.delete(t)

        # puts "#{names[s]} -- #{names[t]}"
        # names[s] += "&#{t}"

        # Merge the groups
        groups[s].merge(groups[t])
        groups.delete(t)
      end
    end

    def part1(input)
      input = "jqt: rhn xhk nvd
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

      g = Networkr::MultiGraph.new
      g = {}
      g = Graph.new

      # names = input.split("\n").flat_map do |line|
      # line.gsub(":", "").split(" ")
      # end.uniq
      #
      nodes = Set.new

      input.strip.split("\n").each do |line|
        name, connected = line.split(": ")
        connected = connected.split(" ")

        # g.add_node(name)

        connected.each do |c|
          # g.add_node(c)
          # g.add_edge(name, c) unless g.has_edge?(name, c)
          # g.add_edge(c, name)
          # g[name] ||= []
          # g[name].push(c)
          # g[c] ||= []
          # g[c].push(name)
          g.add_edge(name, c, 1)
          nodes.add(c)
          nodes.add(name)
        end
      end

      cut, partitions = g.stoer_wagner
      puts cut

      puts partitions.inspect

      return partitions.map(&:length).inspect

      return nil

      loop do
        size, a, b = find_cut(g)
        next unless size == 3

        puts "YES"
        puts a
        puts b
        puts a * b
      end
    end

    def find_cut(g)
      component_size = g.keys.map { |k| [k, 1] }.to_h
      merge = 0

      while g.length > 2
        from = g.keys.sample
        to = g[from].sample

        merged = "merge-#{merge}"
        g[merged] = []

        g[merged] = g[from].concat(g[to])
        g[merged].delete(from)
        g[merged].delete(to)
        g.delete(from)
        g.delete(to)

        g.each do |_k, v|
          while v.include?(from)
            v.delete(from)
            v.push(merged)
          end
          while v.include?(to)
            v.delete(to)
            v.push(merged)
          end
        end

        component_size[merged] = component_size[from] + component_size[to]

        merge += 1
      end

      node_a = g.keys.first
      node_b = g.keys.last

      [g[node_a].length, component_size[node_a], component_size[node_b]]
    end

    def temp
      return nil

      loop do
        g2 = g.deep_copy
        res = karger(g2)

        next if res.nil?

        return res

        # puts res.inspect
        _min, e = res

        if e.length < 12
          puts "FOUND #{e.length}"
          break if e.length == 3
        end
      end

      nil
    end

    def karger(g)
      while g.length > 2
        node1 = g.adj.keys.sample
        node2 = g.children_of(node1).keys.sample
        e = [node1, node2]
        contract(g, node1, node2)
      end
      node1 = g.adj.keys[0]
      node2 = g.adj.keys[1]
      g.adj[node1][node2].length
    end

    def karger_repeated(g)
      g_copy = g.deep_copy

      n = g.length
      mincut = n
      (n**2 * Math.log(n)).to_i.times do
        mincut = karger(g_copy) if karger(g_copy) < mincut
      end
      mincut
    end

    private

    def contract(g, node1, node2)
      g.children_of(node2).each_key do |node|
        g.add_edge(node1, node) if node != node1
        g.adj[node].delete(node2)
      end
      g.adj.delete(node2)
      g.nodes.delete(node2)
    end

    def temp
      counts = {}

      g.keys.sample(3).each do |start|
        g.keys.sample(3).each do |goal|
          next if start == goal

          queue = [[start]]
          final = nil

          until queue.empty?
            path = queue.shift

            if path.last == goal
              final = path
              break
            end

            g[path.last].each do |child|
              next if path.include?(child)

              queue.push(path.clone + [child])
            end
          end

          final.each_cons(2).to_a.each do |pair|
            counts[pair] ||= 0
            counts[pair] += 1
          end
        end
      end

      puts "SAMPLED DONE"

      puts counts.max_by(3, &:last).inspect

      remove = counts.max_by(3) { |_k, v| v }.map(&:first)

      remove.each do |edge|
        from, to = edge
        g[from].delete(to)
        g[to].delete(from)
      end

      queue = [g.keys.first]
      visited = Set.new

      until queue.empty?
        node = queue.shift
        next if visited.include?(node)

        visited.add(node)

        g[node].each do |child|
          next if visited.include?(child)

          queue.push(child)
        end
      end

      num_nodes = g.length
      size_a = visited.length
      size_b = num_nodes - size_a

      size_a * size_b
    end

    def part2(input)
      nil
    end
  end
end
