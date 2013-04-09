require 'minitest/autorun'

class Node
	attr_reader :label
	attr_accessor :cost
	
	def initialize(label)
		@label = label
	end
	
	def cost
		@cost || 0
	end
end

class Graph
	attr_reader :connections, :unvisited, :visited
	
	def initialize 
		@connections = []
		@unvisited = []
		@visited = []
	end
	
	def add_connection(node1, node2, cost)
		@connections << {node1: node1, node2: node2, cost:cost}
		
		set_unvisited node1
		set_unvisited node2
	end
	
	def set_visited (node)
		@visited << node unless @visited.include?(node)
		@unvisited.delete node
	end
	
	def neighbors(node)
		neighbors = @connections.select{|c| c[:node1] == node || c[:node2] == node}
			.map{|h| [h[:node1], h[:node2]]}
			.flatten
			.select{|n| n != node && !visited.include?(n)}
			.uniq
			
		recalculater_costs node, neighbors
	end
	
	private
	
	def find_connection_cost(node1, node2)
		connection = @connections.select do |c| 
			c[:node1] == node1 || c[:node2] == node2 || c[:node1] == node2 || c[:node2] == node1
		end.first
		connection[:cost]
	end
	
	def recalculater_costs current_node, neighbors
		neighbors.each do |node|
			cost = current_node.cost + find_connection_cost(current_node, node)
			node.cost = cost if node.cost == 0 || cost < node.cost
		end
	end
	
	def set_unvisited(node)
		@unvisited << node unless @unvisited.include?(node)
	end
end

class Dijkstra
	attr_reader :graph
	
	def initialize(graph)
		@graph = graph
	end
	
	def solve(start_node, end_node)
		current_node = start_node
		graph.set_visited current_node
		
		target = graph.neighbors(current_node).min {|a, b| a.cost <=> b.cost}
		puts target.inspect
	end
end

describe Dijkstra do
	it 'should find the shortest path' do
		na, nb, nc, nd, ne, nf = [Node.new(:a),Node.new(:b),Node.new(:c),Node.new(:d),Node.new(:e),Node.new(:f)]
		graph = Graph.new
		graph.add_connection na, nb, 7
		graph.add_connection na, nc, 9
		graph.add_connection na, nf, 14
		graph.add_connection nb, nc, 10
		graph.add_connection nb, nd, 15
		graph.add_connection nc, nd, 11
		graph.add_connection nc, nf, 2
		graph.add_connection nd, ne, 6
		graph.add_connection ne, nf, 9
		
		d = Dijkstra.new graph
		d. solve(na,ne).must_equal 'Short path between a and e is [a, b, c, f, e]'
	end
end

describe Graph do
	it 'new instance should not be nil' do
		graph = Graph.new
			
		graph.wont_be_nil
	end
	
	it 'should connect two nodes' do
		graph = Graph.new
			
		n1 = Node.new :a
		n2 = Node.new :b
			
		graph.add_connection n1, n2, 5
		graph.connections.size.must_equal 1
	end
	
	it 'should have nodes information after connection' do
		graph = Graph.new
			
		n1 = Node.new :a
		n2 = Node.new :b
			
		graph.add_connection( n1, n2, 5)

		graph.connections[0][:node1].must_equal n1
		graph.connections[0][:node2].must_equal n2
		graph.connections[0][:cost].must_equal 5
	end
	
	it 'should get neithbors of a node' do
		graph = Graph.new
		
		n1 = Node.new :a
		n2 = Node.new :b
		n3 = Node.new :c
			
		graph.add_connection n1, n2, 5
		graph.add_connection n2, n3, 8
		
		graph.neighbors(n1).size.must_equal 1
		graph.neighbors(n2).size.must_equal 2
	end
	
	it 'should get unvisited neithbors with updated cost' do
		graph = Graph.new
		
		n1 = Node.new :a
		n1.cost = 3
		n2 = Node.new :b
		n3 = Node.new :c
			
		graph.add_connection n1, n2, 5
		graph.add_connection n2, n3, 8
		
		graph.set_visited n3
		
		graph.neighbors(n1)[0].cost.must_equal 8
	end
	
	it 'should get unvisited neithbors without updated cost' do
		graph = Graph.new
		
		n1 = Node.new :a
		n1.cost = 3
		n2 = Node.new :b
		n2.cost = 2
		n3 = Node.new :c
			
		graph.add_connection n1, n2, 5
		graph.add_connection n2, n3, 8
		
		graph.set_visited n3
		
		graph.neighbors(n1)[0].cost.must_equal 2
	end
	
	it 'should get neithbors and updated cost after first level' do
		graph = Graph.new
		
		n1 = Node.new :a
		n1.cost = 3
		n2 = Node.new :b
		n2.cost = 2
		n3 = Node.new :c
			
		graph.add_connection n1, n2, 5
		graph.add_connection n2, n3, 8
		
		graph.neighbors(n1)[0].cost.must_equal 2
		graph.set_visited n1
		graph.neighbors(n2)[0].cost.must_equal 10
	end
end

describe Node do	
	it 'new instance require label' do
		node = Node.new :a
		
		node.wont_be_nil
	end
	
	it 'label should not be nil' do
		node = Node.new :a
		
		node.label.must_equal :a
	end
	
	it 'should be able to set a cost' do
		node = Node.new :a
		node.cost = 10
		
		node.cost.must_equal 10
	end
end