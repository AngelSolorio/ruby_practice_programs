class Path
  attr_accessor :source, :target, :length
  
  def initialize(source, target, length)
    @source = source
    @target = target
    @length = length
  end
end

#This class extends from the Array class 
class Graph < Array
  attr_reader :paths
  
  def initialize
    @paths = []
  end
  
  def connections(node1, node2, length)
  	@paths << Path.new(node1, node2, length)
  	@paths << Path.new(node2, node1, length)
  end

  def get_neighbors(node)
    neighbors = []
    #Goes throught every path in the Graph and stores every nearby nodes in an array
    @paths.each do |path|
      neighbors << path.target if path.source == node
    end
    #Returns the array of neighbors
    return neighbors
  end
 
  def get_length_to(source, target)
  	#Finds the pair of nodes and gets their lenght between them
    @paths.each do |path|
      return path.length if path.source == source and path.target == target or path.source == target and path.target == source 
    end
  end
 
  # This is my implementation of the Dijkstra algorithm
  def get_shortestroad(source, target)
  	#Cleans the arrays
    distances = {}
    visited = {}
    self.each do |node|
      distances[node] = nil
      visited[node] = nil
    end
    
    #Sets the distance to the first node to 0 because it starts there
    distances[source] = 0
    
    #Copy the array of this class to the array 'nodes'
    nodes = self.clone
    until nodes.empty?
    	#Finds the nearest nodes of the array 'nodes'
    	nearest_node = nodes.inject do |node1, node2|
        next node2 unless distances[node1]
        next node1 unless distances[node2]
        next node1 if distances[node1] < distances[node2]
        node2
      end
      
      # returns the length if it reaches the goal
      return distances[target] if nearest_node == target
      
      #Gets the neighbors nodes to the node 'nearest_node'
      neighbors = get_neighbors(nearest_node)
      neighbors.each do |node|
      	#Saves in a temporal variable the sum of the current value + the length between the two nodes
        temp = distances[nearest_node] + nodes.get_length_to(node, nearest_node)
        if distances[node].nil? or temp < distances[node]
          distances[node] = temp
          visited[nodes] = nearest_node
        end
      end
      nodes.delete nearest_node
    end
    
    #Return the result
    if target
      return nil
    else
      return distances
    end
  end
end

#Data to run the program
graph = Graph.new
('A'..'C').each {|node| graph << node}
graph.connections('A', 'B', 4)
graph.connections('A', 'C', 1)
graph.connections('C', 'B', 2)

#Prints the output data
puts "***********************************************"
puts "Nodes of the graph = #{graph}"
puts "Length from node A to node B = #{graph.get_length_to('A', 'B')}"
puts "Neighbors to node A = #{graph.get_neighbors('A')}"
puts "The shortest road from node A to B is = #{graph.get_shortestroad('A', 'B')}"
puts "***********************************************"
