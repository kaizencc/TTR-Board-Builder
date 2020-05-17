//
//  CampusPathsGraphADTExtension.swift
//  CampusPaths
//
//  Created by Dominic Chui on 4/26/20.
//

import Foundation

extension Graph where E == Route {
    
    /**
     
     **Requires**: src and dst are both nodes in the graph
     
     **Modifies**: None
     
     **Effects**: Returns the lowest weight path between src and dst. If no path exists, it returns nil
     
     - Parameter src: the node to start the search from
     dst: the target node
     - Returns: a Path from src to dst if a path exists, otherwise nil
     
     */
    public func findMinimumCostPath(from src: N, to dst: N) -> RoutePath<N>? {
        // Each element is a path from start to a
        // given node. A path's “priority” in the queue is the total
        // cost of that path. Nodes for which no path is known yet are
        // not in the queue.
        var active = PriorityQueue<RoutePath<N>>()
        
        // set of nodes for which we know the minimum-cost path from start.
        var finished: [N] = []
        
        // Add a path from start to each of its children
        for edge in self.getEdges(targetNode: src).filter({ $0.src == src }) {
            let startPath = RoutePath<N>()
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
                    let newPath = RoutePath<N>()
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
