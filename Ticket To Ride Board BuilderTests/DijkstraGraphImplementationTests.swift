//
//  DijkstraGraphImplementationTests.swift
//  Ticket To Ride Board BuilderTests
//
//  Created by Dominic Chui on 5/5/20.
//  Copyright © 2020 CS326. All rights reserved.
//

import XCTest
@testable import Ticket_To_Ride_Board_Builder

class DijkstraGraphTests: XCTestCase {

    func testSimpleRoute() {
        let graph = Graph<String, Route>()
        graph.addNode(withName: "a")
        graph.addNode(withName: "b")
        graph.addNode(withName: "c")
        graph.addEdge(newEdge: Edge(from: "a", to: "b", withLabel: Route(withLength: 3, withColor: Color.red)))
        graph.addEdge(newEdge: Edge(from: "b", to: "c", withLabel: Route(withLength: 5, withColor: Color.blue)))
        graph.addEdge(newEdge: Edge(from: "b", to: "c", withLabel: Route(withLength: 4, withColor: Color.green)))
        
        let minimumRoute = graph.findMinimumCostPath(from: "a", to: "c")!
        
        XCTAssert(minimumRoute.totalWeight == 7)
    }
    
    func testMediumRoute() {
        let graph = Graph<String, Route>()
        graph.addNode(withName: "a")
        graph.addNode(withName: "b")
        graph.addNode(withName: "c")
        graph.addNode(withName: "d")
        graph.addNode(withName: "e")
        
        graph.addEdge(newEdge: Edge(from: "a", to: "b", withLabel: Route(withLength: 3, withColor: Color.red)))
        graph.addEdge(newEdge: Edge(from: "b", to: "c", withLabel: Route(withLength: 1, withColor: Color.blue)))
        graph.addEdge(newEdge: Edge(from: "c", to: "d", withLabel: Route(withLength: 2, withColor: Color.green)))
        graph.addEdge(newEdge: Edge(from: "d", to: "b", withLabel: Route(withLength: 1, withColor: Color.green)))
        graph.addEdge(newEdge: Edge(from: "b", to: "e", withLabel: Route(withLength: 7, withColor: Color.green)))
        
        let minimumRoute = graph.findMinimumCostPath(from: "a", to: "e")!
        
        XCTAssert(minimumRoute.totalWeight == 10)
    }
    
}
