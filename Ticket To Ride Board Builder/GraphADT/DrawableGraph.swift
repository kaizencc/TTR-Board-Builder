//
//  DrawableGraph.swift
//  Ticket To Ride Board Builder
//
//  Created by Dominic Chui on 5/5/20.
//  Copyright © 2020 CS326. All rights reserved.
//

import Foundation
import CoreGraphics

public class DrawableGraph<N: Hashable> {
    
    private let graph : Graph<N, Double>
    private var locations : [N:CGPoint]
    
    /* your abs function and rep invariant */
    
    private func checkRep() {
        graph.checkRep()
    }
    
    public init() {
        graph = Graph<N, Double>()
        locations = [:]
    }
    
    public func getNodes() -> [N] {
        return graph.nodes
    }
    
    public func getEdges() -> [Edge<N,Double>]{
        return graph.edges
    }
    
    public func addNode(withName node: N, withLocation loc: CGPoint) {
        graph.addNode(withName: node)
        locations[node] = loc
    }
    
    public func addEdge(edge: Edge<N, Double>) {
        graph.addEdge(newEdge: edge)
    }
    
    //required: node exists in graph
    public func getLocation(forNode node: N) -> CGPoint {
        return locations[node]!
    }
    
    
}
