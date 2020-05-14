//
//  TTRBModel.swift
//  Ticket To Ride Board Builder
//
//  Created by Dominic Chui on 5/5/20.
//  Copyright © 2020 CS326. All rights reserved.
//

import Foundation
import CoreGraphics


public class TTRBModel: CustomStringConvertible {
    public var description: String {
        get {
            return graph.description
        }
    }
    
    private var graph: DrawableGraph<String, Route>
    
    public init(){
        graph = DrawableGraph<String, Route>()
    }
    
    /**
     
     **Requires**: none
     
     **Modifies**: self
     
     **Effects**: adds a node to the graph with the specified location
     
     - Parameter withName: name of node to be added
     withLocation: location of the node as a CGPoint
     
     */
    public func addNode(withName node: String, withLocation location: CGPoint){
        graph.addNode(withName: node, withLocation: location)
    }
    
    
    /**
     
     **Requires**: the src and dst of the edge are in the graph
     
     **Modifies**: self
     
     **Effects**: adds the specified edge to the graph
     
     - Parameter edge: the edge to be added
     
     */
    public func addEdge(withEdge edge: Edge<String,Route>){
        graph.addEdge(edge)
        let flippedEdge = Edge(from: edge.dst, to: edge.src, withLabel: edge.label)
        graph.addEdge(flippedEdge)
    }
    
    
    /**
     
     **Requires**: the node exists in the graph and has no attached edges
     
     **Modifies**: self
     
     **Effects**: removess the specified node from the graph
     
     - Parameter withName: the node to be removed
     
     */
    public func removeNode(withName node: String){
        graph.removeNode(withName: node)
    }
    
    
    /**
     
     **Requires**: the edge exists in the graph
     
     **Modifies**: self
     
     **Effects**: removess the specified edge from the graph
     
     - Parameter withEdge: the edge to be removed
     
     */
    public func removeEdge(withEdge edge: Edge<String,Route>){
        graph.removeEdge(edge)
        let flippedEdge = Edge(from: edge.dst, to: edge.src, withLabel: edge.label)
        graph.removeEdge(flippedEdge)
    }
    
    
    /**
     
     **Requires**: the node exists in the graph
     
     **Modifies**: self
     
     **Effects**: updates the location of the specified node
     
     - Parameter withName: the node to be moved
     newLocation: the new location for the node
     
     */
    public func moveNode(withName node: String, newLocation loc: CGPoint){
        graph.moveNode(withName: node, newLocation: loc)
    }
    
    
    /**
     
     **Requires**: none
     
     **Modifies**: none
     
     **Effects**: returns list of edges with the specified source and destination
     
     - Parameter src: the start of the edge
                 dst: the end of the edge
     - Returns: List of nodes in edges
     
     */
    public func getEdges(start src: String, end dst: String) -> [Edge<String,Route>] {
        return graph.getEdges().filter({$0.src == src && $0.dst == dst})
    }
    
    
    /**
     
     **Requires**: location is a valid location of a node
     
     **Modifies**: none
     
     **Effects**: returns name of the node at that location
     
     - Parameter point: location of the node to be found
     - Returns: name of the node
     
     */
    public func getNodeName(withLocation point: CGPoint) -> String {
        return graph.getNodeName(withLocation: point)!
    }
    
    
    /**
     
     **Requires**: node exists in the graph
     
     **Modifies**: none
     
     **Effects**: returns location of the node
     
     - Parameter node: name of the node
     - Returns: location of the node
     
     */
    public func getLocation(forNode node: String) -> CGPoint{
        return graph.getLocation(forNode: node)
    }
    
    /**
     
     **Requires**: none
     
     **Modifies**: none
     
     **Effects**: returns list of all nodes in graph
     
     - Returns: list of all nodes
     
     */
    public func getAllNodes() -> [String]{
        return graph.getNodes()
    }
    
    
    /**
     
     **Requires**: none
     
     **Modifies**: self
     
     **Effects**: returns list of all edges in the graph
     
     - Returns: List of nodes in edges
     
     */
    public func getAllEdges() -> [Edge<String,Route>] {
        return graph.getEdges()
    }
    
    /**
     
     **Requires**: src and dst are in the graph
     
     **Modifies**: none
     
     **Effects**: returns number of edges with the same source and destination
     
     - Parameter src: the start node
     dst: the end node
     - Returns: number of edges with the same src and dst
     
     */
    public func numberOfSimilarEdges(src: String, dst: String) -> Int {
        return graph.numberOfSimilarEdges(src: src, dst: dst)
    }
    
//    // TODO change to description
//    public func printGraph() {
//        print(graph.getNodes())
//        print(graph.getEdges())
//    }
    
}
