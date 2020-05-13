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
    private var graph: DrawableGraph<String, Route>
    
    public init(){
        graph = DrawableGraph<String, Route>()
    }
    
    public func addNode(withName node: String, withLocation location: CGPoint){
        graph.addNode(withName: node, withLocation: location)
    }
    
    // exact duplicates can only be added if they are gray
    public func addEdge(withEdge edge: Edge<String,Route>){
//        //if an edge already exists between the src and dst, replace it
//        let existingEdges = graph.getEdges().filter({ ($0.src == edge.src && $0.dst == edge.dst) ||
//                                                      ($0.src == edge.dst && $0.dst == edge.src) })
//        if existingEdges.count != 0 {
//            for edge in existingEdges {
//                graph.removeEdge(edge)
//            }
//        }
        //let edges = graph.getEdges()
        //if (!edges.contains(edge) /* || edge.label.color == Color.gray*/) {
        graph.addEdge(edge)
        let flippedEdge = Edge(from: edge.dst, to: edge.src, withLabel: edge.label)
        graph.addEdge(flippedEdge)
        //}
    }
    
    public func removeNode(withName node: String){
        graph.removeNode(withName: node)
    }
    
    public func removeEdge(withEdge edge: Edge<String,Route>){
        graph.removeEdge(edge)
        let flippedEdge = Edge(from: edge.dst, to: edge.src, withLabel: edge.label)
        graph.removeEdge(flippedEdge)
    }
    
    public func moveNode(withName node: String, newLocation loc: CGPoint){
        graph.moveNode(withName: node, newLocation: loc)
    }
    
    //required: there is an edge between src and dst
    public func getEdge(start src: String, end dst: String) -> Edge<String,Route> {
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
    
    public func getAllEdges() -> [Edge<String,Route>] {
        return graph.getEdges()
    }
    
    public func amountOfSimilarEdges(src: String, dst: String) -> Int {
        return graph.similarEdges(src: src, dst: dst)
    }
    
    public func printGraph() {
        print(graph.getNodes())
        print(graph.getEdges())
    }
    
}
