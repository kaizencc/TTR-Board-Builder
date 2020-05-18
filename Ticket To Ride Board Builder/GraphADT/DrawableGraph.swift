//
//  DrawableGraph.swift
//  Ticket To Ride Board Builder
//
//  Created by Dominic Chui on 5/5/20.
//  Copyright © 2020 CS326. All rights reserved.
//

import Foundation
import CoreGraphics


/**
 This class represents a drawable multigraph.
 
 **Abstract Invariant**: each node in the graph must have a corresponding location
 
 
 */
public class DrawableGraph<N: Hashable, E: Comparable>: CustomStringConvertible {
    
    private let graph : Graph<N, E>
    private var locations : [N:CGPoint]
    
    public var description: String {
        get {
            var description = "Nodes:\n"
            for node in graph.nodes {
                description.append("\(node)\n")
            }
            description.append("\nEdges:\n")
            for edge in graph.edges {
                description.append("(\(edge.src), \(edge.dst), \(edge.label))\n")
            }
            return description
        }
    }
    
    
    // Representation Invariant: for node in graph.nodes, locations[node] != nil
    //
    // Abstraction Function: G is a drawable graph such that the vertices are nodes in graph.nodes, edges and edges in graph.edges, and the location of each node is in location[node]
    
    private func checkRep() {
        graph.checkRep()
        for node in graph.nodes {
            assert(locations[node] != nil)
        }
    }
    
    /**
     
     **Requires**: none
     
     **Modifies**: self
     
     **Effects**: creates an empty graph
     
     */
    public init() {
        graph = Graph<N, E>()
        locations = [:]
        checkRep()
    }
    
    /**
     
     **Requires**: none
     
     **Modifies**: self
     
     **Effects**: returns list of all nodes in the graph
     
     - Returns: List of nodes in graph
     
     */
    public func getNodes() -> [N] {
        checkRep()
        return graph.nodes
    }
    
    
    /**
     
     **Requires**: none
     
     **Modifies**: self
     
     **Effects**: returns list of all edges in the graph
     
     - Returns: List of nodes in edges
     
     */
    public func getEdges() -> [Edge<N,E>]{
        checkRep()
        return graph.edges
    }
    
    
    /**
     
     **Requires**: none
     
     **Modifies**: self
     
     **Effects**: adds a node to the graph with the specified location
     
     - Parameter withName: name of node to be added
                 withLocation: location of the node as a CGPoint
     
     */
    public func addNode(withName node: N, withLocation loc: CGPoint) {
        checkRep()
        graph.addNode(withName: node)
        locations[node] = loc
        checkRep()
    }
    
    /**
     
     **Requires**: the src and dst of the edge are in the graph
     
     **Modifies**: self
     
     **Effects**: adds the specified edge to the graph
     
     - Parameter edge: the edge to be added
     
     */
    public func addEdge(_ edge: Edge<N, E>) {
        checkRep()
        graph.addEdge(newEdge: edge)
        checkRep()
    }
    
    /**
     
     **Requires**: the node exists in the graph
     
     **Modifies**: none
     
     **Effects**: returns location of the specified node
     
     - Parameter forNode: name of the node to find location for
     - Returns: location of the node
     
     */
    public func getLocation(forNode node: N) -> CGPoint {
        checkRep()
        return locations[node]!
    }
    
    /**
    
    **Requires**: the location exists in the graph
    
    **Modifies**: none
    
    **Effects**: returns name of node at specified location
    
    - Parameter withLocation: location of the node to find name for
    - Returns: name of the node
    
    */
    public func getNodeName(withLocation loc: CGPoint) -> N? {
        checkRep()
        for node in locations.keys {
            if locations[node] == loc {
                return node
            }
        }
        return nil
    }
    
    public func contains(withName name: N) -> Bool {
        checkRep()
        return graph.contains(node: name)
    }
    
    
    /**
     
     **Requires**: the node exists in the graph and has no attached edges
     
     **Modifies**: self
     
     **Effects**: removess the specified node from the graph
     
     - Parameter withName: the node to be removed
     
     */
    public func removeNode(withName node: N){
        checkRep()
        graph.removeNode(withName: node)
        locations[node] = nil
        checkRep()
    }
    
    /**
     
     **Requires**: the edge exists in the graph
     
     **Modifies**: self
     
     **Effects**: removess the specified edge from the graph
     
     - Parameter withEdge: the edge to be removed
     
     */
    public func removeEdge(_ edge: Edge<N,E>){
        checkRep()
        graph.removeEdge(targetEdge: edge)
        checkRep()
    }
    
    /**
     
     **Requires**: the node exists in the graph
     
     **Modifies**: self
     
     **Effects**: updates the location of the specified node
     
     - Parameter withName: the node to be moved
                 newLocation: the new location for the node
     
     */
    public func moveNode(withName node: N, newLocation loc: CGPoint){
        checkRep()
        locations[node] = loc
        checkRep()
    }
    
    /**
     
     **Requires**: src and dst are in the graph
     
     **Modifies**: none
     
     **Effects**: returns number of edges with the same source and destination
     
     - Parameter src: the start node
                 dst: the end node
     - Returns: number of edges with the same src and dst
     
     */
    public func numberOfSimilarEdges(src start: N, dst end: N) -> Int {
        var similar = 0
        let edges = graph.edges
        for edge in edges{
            if edge.src == start && edge.dst == end{
                similar = similar + 1
            }
        }
        return similar
    }
    
}

extension DrawableGraph where E == Route {
    public func findMinCostPath(src start: N, dst end: N) -> RoutePath<N>?{
        return graph.findMinimumCostPath(from: start, to: end)
    }
}
