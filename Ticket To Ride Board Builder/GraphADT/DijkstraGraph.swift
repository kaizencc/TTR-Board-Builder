//
//  CampusPathsGraphADTExtension.swift
//  CampusPaths
//
//  Created by Dominic Chui on 4/26/20.
//

import Foundation

extension Graph where E == Double {
    
    /**
     
     **Requires**: json is a dictionary containing graph data to be initialized: the key "nodes" has a list of nodes as its value,
     the key "edges" has a list of edges as its value where the edges must have labels of type double
     
     **Modifies**: self
     
     **Effects**: Creates an non-empty graph from the given data
     
     - Parameter json: the dictionary containing the graph data
     
     */
    public convenience init(graphJSON json: [String:Any], nodeName dataNodes: String, edgeName dataEdges: String) {
        self.init()
        
        if let nodes = json[dataNodes] as? [N] {
            for node in nodes {
                self.addNode(withName: node)
            }
        }
        
        if let edges = json[dataEdges] as? [[String: Any]] {
            for edge in edges {
                self.addEdge(newEdge: Edge<N,E>(from: (edge["src"]! as? N)!, to: (edge["dst"]! as? N)!, withLabel: edge["label"]! as! Double))
            }
        }
    }
    
    /**
     
     **Requires**: src and dst are both nodes in the graph
     
     **Modifies**: None
     
     **Effects**: Returns the lowest weight path between src and dst. If no path exists, it returns nil
     
     - Parameter src: the node to start the search from
     dst: the target node
     - Returns: a Path from src to dst if a path exists, otherwise nil
     
     */
    public func findMinimumCostPath(from src: N, to dst: N) -> Path<N, Double>? {
        // Each element is a path from start to a
        // given node. A path's “priority” in the queue is the total
        // cost of that path. Nodes for which no path is known yet are
        // not in the queue.
        var active = PriorityQueue<Path<N, Double>>()
        
        // set of nodes for which we know the minimum-cost path from start.
        var finished: [N] = []
        
        // Add a path from start to each of its children
        for edge in self.getEdges(targetNode: src).filter({ $0.src == src }) {
            let startPath = Path<N, E>()
            startPath.add(edge)
            active.push(startPath)
        }
        
        while (!active.isEmpty) {
            // minPath is the lowest-cost path in active and is the
            // minimum-cost path to some node
            let minPath = active.pop()!
            let minDest = minPath.dst!
            
            if minDest == dst {
                return minPath
            }
            
            if finished.contains(minDest) {
                continue
            }
            
            // for each edge such that minDest is the src
            for edge in self.getEdges(targetNode: minDest).filter({ $0.src == minDest }) {
                // If we don't know the minimum-cost path from start to child,
                // examine the path we've just found
                if !finished.contains(edge.dst) {
                    let newPath = Path<N,E>()
                    for edge in minPath.edges {
                        newPath.add(edge)
                    }
                    newPath.add(edge)
                    active.push(newPath)
                }
            }
            finished.append(minDest)
        }
        // No path exists if the loop terminates
        return nil
    }
}
