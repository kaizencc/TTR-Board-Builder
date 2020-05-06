//
//  EdgeADT.swift
//  GraphADT
//
//  Created by Dominic Chui on 4/9/20.
//

import Foundation


/**
 This struct represents an immutable edge.
 
 **Specification Properties**:
 - src: String - The node where the edge starts
 - dst: String - The node where the edge ends
 - label: String - The label of the edge
 
 **Abstract Invariant**: None
 
 */
public struct Edge<Node: Equatable, Label: Comparable>: Comparable {
    
    // Representation Invariant: none
    //
    // Abstraction Function: E is an edge starting at the node "src" and ending at the node "dst" with the label "label"
    
    public let src: Node
    public let dst: Node
    public let label: Label
    
    public init(from: Node, to: Node, withLabel: Label) {
        self.src = from
        self.dst = to
        self.label = withLabel
    }
    
    /**
     
     **Requires**: None
     
     **Modifies**: None
     
     **Effects**: Returns whether two edges are the same
     
     - Parameter lhs: first edge
     rhs: second edge
     - Returns: True if the edges have the same src, dst, and label
     
     */
    public static func == (lhs: Edge, rhs: Edge) -> Bool {
        return lhs.src   == rhs.src
            && lhs.dst   == rhs.dst
            && lhs.label == rhs.label
    }
    
    /**
     
     **Requires**: None
     
     **Modifies**: None
     
     **Effects**: Returns whether the first edge's label is less than the second edge's label
     
     - Parameter lhs: first edge
     rhs: second edge
     - Returns: true if lhs.label is less than rhs.label
     
     */
    public static func < (lhs: Edge<Node, Label>, rhs: Edge<Node, Label>) -> Bool {
        return lhs.label < rhs.label
    }
}
