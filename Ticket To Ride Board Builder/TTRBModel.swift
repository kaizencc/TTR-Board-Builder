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
    }
    
    public func removeNode(withName node: String){
        graph.removeNode(withName: node)
    }
    
    public func removeEdge(withEdge edge: Edge<String,Int>){
        graph.removeEdge(withEdge: edge)
    }
    
    public func moveNode(withName node: String, newLocation loc: CGPoint){
        graph.moveNode(withName: node, newLocation: loc)
    }
    
    //required: there is an edge between src and dst
    public func getEdge(start src: String, end dst: String) -> Edge<String,Int> {
        return graph.getEdges().filter({$0.src == src && $0.dst == dst}).first!
    }
    
    public func getAllNodes() -> [String]{
        return graph.getNodes()
    }
    
    public func getAllEdges() -> [Edge<String,Int>] {
        return graph.getEdges()
    }
    
    
}
