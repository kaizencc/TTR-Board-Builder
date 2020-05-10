//
//  TTRBModel.swift
//  Ticket To Ride Board Builder
//
//  Created by Dominic Chui on 5/5/20.
//  Copyright © 2020 CS326. All rights reserved.
//

import Foundation
import CoreGraphics


public class TTRBModel {
    
    //potentially need []
    private var graph: DrawableGraph<String, Int>
    
    public init(){
        graph = DrawableGraph<String, Int>()
    }
    
    public func addNode(withName node: String, withLocation location: CGPoint){
        graph.addNode(withName: node, withLocation: location)
    }
    
    public func addEdge(withEdge edge: Edge<String,Int>){
        graph.addEdge(edge)
        let flippedEdge = Edge(from: edge.dst, to: edge.src, withLabel: edge.label)
        graph.addEdge(flippedEdge)
    }
    
    public func removeNode(withName node: String){
        graph.removeNode(withName: node)
    }
    
    public func removeEdge(withEdge edge: Edge<String,Int>){
        graph.removeEdge(edge)
        let flippedEdge = Edge(from: edge.dst, to: edge.src, withLabel: edge.label)
        graph.removeEdge(flippedEdge)
    }
    
    public func moveNode(withName node: String, newLocation loc: CGPoint){
        graph.moveNode(withName: node, newLocation: loc)
    }
    
    //required: there is an edge between src and dst
    public func getEdge(start src: String, end dst: String) -> Edge<String,Int> {
        return graph.getEdges().filter({$0.src == src && $0.dst == dst}).first!
    }
    
    //required: location is a valid location of a node
    public func getNodeName(withLocation point: CGPoint) -> String{
        return graph.getNodeName(withLocation: point)!
    }
    
    //required: node exists in the graph
    public func getLocation(forNode node: String) -> CGPoint{
        return graph.getLocation(forNode: node)
    }
    
    public func getAllNodes() -> [String]{
        return graph.getNodes()
    }
    
    public func getAllEdges() -> [Edge<String,Int>] {
        return graph.getEdges()
    }
    
    public func printGraph() {
        print(graph.getNodes())
        print(graph.getEdges())
    }
    
}
