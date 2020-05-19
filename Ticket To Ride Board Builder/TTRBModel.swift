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
    
    //calculates the distance between two CGPoints
    private func CGPointDistance(from: CGPoint, to: CGPoint) -> CGFloat {
        return sqrt((from.x - to.x) * (from.x - to.x) + (from.y - to.y) * (from.y - to.y))
    }
    
    //calculates what the edge length should be after adding an edge or moving a point
    public func calculateEdgeLength(start src: CGPoint, end dst: CGPoint) -> Int{
        let distance = CGPointDistance(from: src, to: dst)
        return Int(distance/100) + 1
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
        updateAllEdges(withName: node)
    }
    
    //private function called by move() to update edges with the moved node
    private func updateAllEdges(withName node: String){
        let edges = graph.getEdges()
        for edge in edges{
            if edge.src == node || edge.dst == node {
                let newLength = calculateEdgeLength(start: graph.getLocation(forNode: edge.src), end: graph.getLocation(forNode: edge.dst))
                updateEdge(edge: edge, newLength: newLength)
            }
        }
    }
    
    //private function called by updateAllEdges() to remove old edge and add in updated edge
    private func updateEdge(edge: Edge<String,Route>, newLength length: Int){
        let newEdge = Edge<String,Route>(from: edge.src, to: edge.dst, withLabel: Route(withLength: length, withColor: edge.label.color))
        graph.removeEdge(edge)
        graph.addEdge(newEdge)
    }
    
    
    /**
    
    **Requires**: none
    
    **Modifies**: none
    
    **Effects**: none
    
    - Parameter withName: a possible node in the graph
    - Returns: true if node name is in graph
    
    */
    public func containsNode(withName node: String) -> Bool {
        return graph.contains(withName: node)
    }
    
    
    /**
     
     **Requires**: none
     
     **Modifies**: none
     
     **Effects**: returns list of edges with the specified source and destination
     
     - Parameter src: the start of the edge
                 dst: the end of the edge
     - Returns: List of edges
     
     */
    public func getEdges(start src: String, end dst: String) -> [Edge<String,Route>] {
        return graph.getEdges().filter({$0.src == src && $0.dst == dst})
    }
    
    /**
        
        **Requires**: none
        
        **Modifies**: none
        
        **Effects**: returns list of edges with the specified source
        
        - Parameter src: the start of the edge
        - Returns: List of edges
        
        */
    public func getNodeEdges(start src: String) -> [Edge<String,Route>]{
        return graph.getEdges().filter({$0.src == src})
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
    
    public func findMinCostPath(src start: String, dst end: String) -> RoutePath<String>? {
        return graph.findMinCostPath(src: start, dst: end)
    }
    
    /**
     
     **Requires**: none
     
     **Modifies**: none
     
     **Effects**: removes all nodes and edges in the graph
     
     */
    public func clearGraph() {
        graph = DrawableGraph<String, Route>()
    }
    
    /**
    
    **Requires**: none
    
    **Modifies**: none
    
    **Effects**: none
     
     - Returns: random node in graph
    
    */
    public func randomNode() -> String {
        let index = Int.random(in: 0..<graph.getNodes().count)
        return graph.getNodes()[index]
    }
    
}
