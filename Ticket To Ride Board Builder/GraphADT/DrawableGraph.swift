//
//  DrawableGraph.swift
//  Ticket To Ride Board Builder
//
//  Created by Dominic Chui on 5/5/20.
//  Copyright © 2020 CS326. All rights reserved.
//

import Foundation
import CoreGraphics

public class DrawableGraph<N: Hashable, E: Comparable> {
    
    private let graph : Graph<N, E>
    private var locations : [N:CGPoint]
    
    /* your abs function and rep invariant */
    
    private func checkRep() {
        graph.checkRep()
    }
    
    public init() {
        graph = Graph<N, E>()
        locations = [:]
    }
    
    public func getNodes() -> [N] {
        return graph.nodes
    }
    
    public func getEdges() -> [Edge<N,E>]{
        return graph.edges
    }
    
    public func addNode(withName node: N, withLocation loc: CGPoint) {
        graph.addNode(withName: node)
        locations[node] = loc
    }
    
    public func addEdge(edge: Edge<N, E>) {
        graph.addEdge(newEdge: edge)
    }
    
    //required: node exists in graph
    public func getLocation(forNode node: N) -> CGPoint {
        return locations[node]!
    }
    
    public func removeNode(withName node: N){
        graph.removeNode(withName: node)
        locations[node] = nil
    }
    
    public func removeEdge(withEdge edge: Edge<N,E>){
        graph.removeEdge(targetEdge: edge)
    }
    
    //required: node exists in graph
    public func moveNode(withName node: N, newLocation loc: CGPoint){
        locations[node] = loc
    }
    
    
}
