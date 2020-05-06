//
//  Graph.swift
//  GraphADT
//

import Foundation


/**
 This class represents a generic mutable multigraph.
 
 **Derived Specification Properties**:
 - nodes: Generic - All nodes in the graph
 - edges: Generic - All edges in the graph between two nodes in the graph
 
 **Abstract Invariant**: The source and destination of an edge must be nodes in the graph
 
 
 */
public class Graph<N: Hashable, E: Comparable>  {
    
    private let debug = false
    
    // Representation Invariant: for edge in adjacencyList.values, adjacencyList.contains(edge.src) && adjacencyList.contains(edge.dst)
    //
    // Abstraction Function: G is a graph such that the vertices are keys in adjacencyList and the edges are values in adjacencyList,
    //                       where an edge = <edge.src, edge.dst> with label edge.label
    
    
    // A property that holds a dictionary associating nodes with its outgoing edges
    private var adjacencyList: [N: MutableArray<Edge<N,E>>]
    
    
    // A computed property listing all the nodes in the graph
    public var nodes: [N] {
        get {
            return Array(adjacencyList.keys)
        }
    }
    
    // A computed property listing all the edges in the graph
    public var edges: [Edge<N,E>] {
        get {
            let edges = Array(adjacencyList.values)
            return edges.reduce([], { $0 + $1 })
        }
    }
    
    // verify the rep invariant holds
    // only for verification of graph integrity inside Graph and its extensions
    public func checkRep() {
        if (debug) {
            for edgeList in adjacencyList.values {
                for edge in edgeList {
                    assert(adjacencyList.keys.contains(edge.src))
                    assert(adjacencyList.keys.contains(edge.dst))
                }
            }
        }
    }
    
    
    /**
     
     **Requires**: none
     
     **Modifies**: self
     
     **Effects**: Creates an empty graph
     
     */
    public init() {
        adjacencyList = [:]
        checkRep()
    }
    
    
    /**
     
     **Requires**: The src and dst of all elements of edges must be elements of nodes
     
     **Modifies**: self
     
     **Effects**: Creates an non-empty graph with the given nodes and edges
     
     - Parameter nodes: the list of nodes to add
     edges: the list of edges to add
     
     */
    public init(nodes: [N], edges: [Edge<N,E>]) {
        
        var dict: [N: MutableArray<Edge<N,E>>] = [:]
        
        for node in nodes {
            dict[node] = MutableArray<Edge<N,E>>()
        }
        for edge in edges {
            dict[edge.src]!.append(edge)
        }
        
        adjacencyList = dict
        checkRep()
    }
    
    
    /**
     
     **Requires**: None
     
     **Modifies**: self
     
     **Effects**: Creates an graph with the given adjacency list
     
     - Parameter nodes: the list of nodes to add
     edges: the list of edges to add
     
     */
    private init(adjacencyList: [N: MutableArray<Edge<N,E>>]) {
        self.adjacencyList = adjacencyList
        checkRep()
    }
    
    
    /**
     
     **Requires**: None
     
     **Modifies**: None
     
     **Effects**: Returns all edges in the graph between two specified nodes
     
     - Parameter src: node where the edge(s) start
     dst: node where the edge(s) end
     - Returns: list of edges
     
     */
    public func getEdges(src: N, dst: N) -> [Edge<N,E>] {
        checkRep()
        return adjacencyList[src]!.filter({ $0.dst == dst })
    }
    
    
    /**
     
     **Requires**: targetNode is in the graph
     
     **Modifies**: None
     
     **Effects**: Returns all edges whose src or dst is sourceNode
     
     - Parameter targetNode: node whose incoming and outgoing edges are being found
     - Returns: list of edges starting or ending at targetNode
     
     */
    public func getEdges(targetNode: N) -> [Edge<N,E>] {
        checkRep()
        return self.edges.filter( {$0.src == targetNode || $0.dst == targetNode })
    }
    
    
    /**
     
     **Requires**: sourceNode is in the graph
     
     **Modifies**: None
     
     **Effects**: Returns all nodes connected by an edge starting at sourceNode
     
     - Parameter src: node whose neighbors are being found
     - Returns: list of nodes connected to sourceNode by an edge src
     
     */
    public func getChildren(src: N) -> [N] {
        checkRep()
        let outgoingEdges: MutableArray<Edge<N,E>> = adjacencyList[src]!
        // remove duplicate nodes with a set
        let nodes = outgoingEdges.map({ $0.dst })
        return Array(Set(nodes))
    }
    
    
    
    /**
     
     **Requires**: None
     
     **Modifies**: None
     
     **Effects**: Returns whether node is in the graph
     
     - Parameter node: node whose presence is to be determined
     - Returns: Bool describing whether node is present in the graph
     
     */
    public func contains(node: N) -> Bool {
        checkRep()
        return adjacencyList.keys.contains(node)
    }
    
    
    
    /**
     
     **Requires**: node is not already in the graph
     
     **Modifies**: self
     
     **Effects**: Adds the new node to this graph
     
     - Parameter withName: the new node to be added to the graph
     - Returns: none
     
     */
    public func addNode(withName: N) {
        checkRep()
        adjacencyList[withName] = MutableArray<Edge<N,E>>()
        checkRep()
    }
    
    /**
     
     **Requires**: node has no incoming or outgoing edges
     
     **Modifies**: self
     
     **Effects**: Removes the node from the graph
     
     - Parameter withName: the node to be removed from the graph
     - Returns: none
     
     */
    public func removeNode(withName: N) {
        checkRep()
        adjacencyList.removeValue(forKey: withName)
        checkRep()
    }
    
    /**
     
     **Requires**: src and dst of the edge are nodes in the graph
     
     **Modifies**: self
     
     **Effects**: adds the new edge to the graph; if newEdge is already in the graph, it adds another copy
     
     - Parameter newEdge: the new edge to be added to the graph
     - Returns: none
     
     */
    public func addEdge(newEdge: Edge<N,E>) {
        checkRep()
        adjacencyList[newEdge.src]!.append(newEdge)
        checkRep()
    }
    
    /**
     
     **Requires**: There is an edge in the graph with targetEdge's src, dst, and label
     
     **Modifies**: self
     
     **Effects**: removes the edge from the graph, if there are multiple copies of an edge, only one is removed
     
     - Parameter targetEdge: the edge to be removed
     - Returns: none
     
     */
    public func removeEdge(targetEdge: Edge<N,E>) {
        checkRep()
        let sourceNode = targetEdge.src
        let edges = adjacencyList[sourceNode]
        let newEdges = MutableArray<Edge<N,E>>()
        for edge in edges! {
            if edge != targetEdge {
                newEdges.append(edge)
            }
        }
        adjacencyList[sourceNode] = newEdges
        checkRep()
    }
    
}
