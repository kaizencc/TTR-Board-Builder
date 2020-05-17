//
//  PathADT.swift
//  CampusPaths
//
//  Created by Dominic Chui on 4/27/20.
//

import Foundation

/**
 This class represents a path between two nodes in a graph.
 
 **Derived Specification Properties**:
 - totalWeight: Numeric - The sum of the weights of all edges in the path.
 - edges: Generic - All edges in the path between two nodes in the graph
 
 **Abstract Invariant**: For every edge in path, the dst of an edge must be the src of the next edge
 
 */
public class RoutePath<N: Hashable>: Comparable  {
    
    // Representation Invariant: For every edge e in edgeList, edgeList[i].dst == edgeList[i+1].src
    //
    // Abstraction Function: P is a path composed of edges starting at node src and ending at node dst.
    
    private var edgeList: [Edge<N, Route>]
    
    // The sum of the weights of all the edges in the path
    public var totalWeight: Int
    
    public var edges: [Edge<N, Route>] {
        get {
            return edgeList
        }
    }
    
    public var dst: N? {
        get {
            if !edgeList.isEmpty {
                return edgeList.last!.dst
            } else {
                return nil
            }
        }
    }
    
    private func checkRep() {
        if !edgeList.isEmpty {
            for n in 0..<edgeList.count-1 {
                assert(edgeList[n].dst == edgeList[n+1].src)
            }
        }
    }
    /**
     
     **Requires**: None
     
     **Modifies**: self
     
     **Effects**: Initializes an empty path object
     
     */
    public init() {
        edgeList = []
        totalWeight = 0
        checkRep()
    }
    
    /**
     
     **Requires**: The src of the added edge must be the dst of the last edge in self
     
     **Modifies**: self
     
     **Effects**: Adds the new edge to the path
     
     - Parameter edge: the edge to be added
     
     */
    public func add(_ edge: Edge<N, Route>) {
        checkRep()
        edgeList.append(edge)
        totalWeight += edge.label.length
        checkRep()
    }
    
    /**
     
     **Requires**: None
     
     **Modifies**: None
     
     **Effects**: Returns whether the total weight of the first path is less than the total weight of the second path.
     
     - Parameter lhs: first edge
     rhs: second edge
     - Returns: True if the total weight of lhs is less than the total weight of rhs
     
     */
    public static func < (lhs: RoutePath<N>, rhs: RoutePath<N>) -> Bool {
        lhs.checkRep()
        rhs.checkRep()
        return lhs.totalWeight < rhs.totalWeight
    }
    
    /**
     
     **Requires**: None
     
     **Modifies**: None
     
     **Effects**: Returns whether the total weight of the first path is equal to the total weight of the second path.
     
     - Parameter lhs: first edge
     rhs: second edge
     - Returns: True if the total weight of lhs equal to the total weight of rhs, and false otherwise
     
     */
    public static func == (lhs: RoutePath<N>, rhs: RoutePath<N>) -> Bool {
        lhs.checkRep()
        rhs.checkRep()
        return lhs.totalWeight == rhs.totalWeight
    }
    
}

