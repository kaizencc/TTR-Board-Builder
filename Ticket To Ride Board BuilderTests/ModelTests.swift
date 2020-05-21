//
//  ModelTests.swift
//  Ticket To Ride Board BuilderTests
//
//  Created by Dominic Chui on 5/12/20.
//  Copyright © 2020 CS326. All rights reserved.
//
import XCTest
@testable import Ticket_To_Ride_Board_Builder

class ModelTests: XCTestCase {

    func testAddOneNode() {
        let model = TTRBModel()
        model.addNode(withName: "1", withLocation: CGPoint(x: 0.0, y: 0.0))
        XCTAssert(model.getAllNodes() == ["1"])
    }
    
    func testAddTwoNodes() {
        let model = TTRBModel()
        model.addNode(withName: "1", withLocation: CGPoint(x: 0.0, y: 0.0))
        model.addNode(withName: "2", withLocation: CGPoint(x: 0.5, y: 0.0))

        XCTAssert(Set(model.getAllNodes()) == Set(arrayLiteral: "1", "2"))
    }
    
    func testAddIdenticalNodes() {
        let model = TTRBModel()
        model.addNode(withName: "1", withLocation: CGPoint(x: 0.0, y: 0.0))
        model.addNode(withName: "1", withLocation: CGPoint(x: 0.0, y: 0.0))
        XCTAssert(model.getAllNodes() == ["1"])
    }
    
    func testAddEdge() {
        let model = TTRBModel()
        model.addNode(withName: "1", withLocation: CGPoint(x: 0.0, y: 0.0))
        model.addNode(withName: "2", withLocation: CGPoint(x: 5.0, y: 5.0))
        model.addEdge(withEdge: Edge(from: "1", to: "2", withLabel: Route(withLength: 5, withColor: Color.white)))
        XCTAssert(model.getAllEdges().contains(Edge(from: "1", to: "2", withLabel: Route(withLength: 5, withColor: Color.white))))
        XCTAssert(model.getAllEdges().contains(Edge(from: "2", to: "1", withLabel: Route(withLength: 5, withColor: Color.white))))
    }
    
    func testAddDuplicateNonGrayEdge() {
        let model = TTRBModel()
        model.addNode(withName: "1", withLocation: CGPoint(x: 0.0, y: 0.0))
        model.addNode(withName: "2", withLocation: CGPoint(x: 5.0, y: 5.0))
        model.addEdge(withEdge: Edge(from: "1", to: "2", withLabel: Route(withLength: 5, withColor: Color.red)))
        model.addEdge(withEdge: Edge(from: "1", to: "2", withLabel: Route(withLength: 5, withColor: Color.red)))
        XCTAssert(model.getAllEdges().contains(Edge(from: "1", to: "2", withLabel: Route(withLength: 5, withColor: Color.red))))
        XCTAssert(model.getAllEdges().contains(Edge(from: "2", to: "1", withLabel: Route(withLength: 5, withColor: Color.red))))
    }
    
    func testAddDuplicateGrayEdge() {
        let model = TTRBModel()
        model.addNode(withName: "1", withLocation: CGPoint(x: 0.0, y: 0.0))
        model.addNode(withName: "2", withLocation: CGPoint(x: 5.0, y: 5.0))
        model.addEdge(withEdge: Edge(from: "1", to: "2", withLabel: Route(withLength: 5, withColor: Color.gray)))
        model.addEdge(withEdge: Edge(from: "1", to: "2", withLabel: Route(withLength: 5, withColor: Color.gray)))
        XCTAssert(model.getAllEdges().contains(Edge(from: "1", to: "2", withLabel: Route(withLength: 5, withColor: Color.gray))))
        XCTAssert(model.getAllEdges().contains(Edge(from: "2", to: "1", withLabel: Route(withLength: 5, withColor: Color.gray))))
        XCTAssert(model.getAllEdges().count == 4)
    }
    
    func testAddOppositeDuplicateEdge() {
        let model = TTRBModel()
        model.addNode(withName: "1", withLocation: CGPoint(x: 0.0, y: 0.0))
        model.addNode(withName: "2", withLocation: CGPoint(x: 5.0, y: 5.0))
        model.addEdge(withEdge: Edge(from: "1", to: "2", withLabel: Route(withLength: 5, withColor: Color.blue)))
        model.addEdge(withEdge: Edge(from: "2", to: "1", withLabel: Route(withLength: 3, withColor: Color.yellow)))
        XCTAssert(model.getAllEdges().contains(Edge(from: "1", to: "2", withLabel: Route(withLength: 5, withColor: Color.blue))))
        XCTAssert(model.getAllEdges().contains(Edge(from: "2", to: "1", withLabel: Route(withLength: 5, withColor: Color.blue))))
        XCTAssert(model.getAllEdges().contains(Edge(from: "1", to: "2", withLabel: Route(withLength: 3, withColor: Color.yellow))))
        XCTAssert(model.getAllEdges().contains(Edge(from: "2", to: "1", withLabel: Route(withLength: 3, withColor: Color.yellow))))
    }
    
    func testAddNonGraytoGrayEdges() {
        let model = TTRBModel()
        model.addNode(withName: "1", withLocation: CGPoint(x: 0.0, y: 0.0))
        model.addNode(withName: "2", withLocation: CGPoint(x: 5.0, y: 5.0))
        model.addEdge(withEdge: Edge(from: "1", to: "2", withLabel: Route(withLength: 5, withColor: Color.gray)))
        model.addEdge(withEdge: Edge(from: "1", to: "2", withLabel: Route(withLength: 5, withColor: Color.blue)))
        XCTAssert(model.getAllEdges().contains(Edge(from: "1", to: "2", withLabel: Route(withLength: 5, withColor: Color.gray))))
        XCTAssert(model.getAllEdges().contains(Edge(from: "2", to: "1", withLabel: Route(withLength: 5, withColor: Color.blue))))
        XCTAssert(model.getAllEdges().count == 4)
    }
    
    func testAmountOfSimilarEdges() {
        let model = TTRBModel()
        model.addNode(withName: "1", withLocation: CGPoint(x: 0.0, y: 0.0))
        model.addNode(withName: "2", withLocation: CGPoint(x: 5.0, y: 5.0))
        model.addNode(withName: "3", withLocation: CGPoint(x: 10.0, y: 10.0))
        model.addEdge(withEdge: Edge(from: "1", to: "2", withLabel: Route(withLength: 5, withColor: Color.gray)))
        model.addEdge(withEdge: Edge(from: "1", to: "2", withLabel: Route(withLength: 5, withColor: Color.blue)))
        model.addEdge(withEdge: Edge(from: "1", to: "2", withLabel: Route(withLength: 5, withColor: Color.green)))
        model.addEdge(withEdge: Edge(from: "2", to: "3", withLabel: Route(withLength: 5, withColor: Color.blue)))
        XCTAssert(model.numberOfSimilarEdges(src: "2", dst: "3") == 1)
        XCTAssert(model.numberOfSimilarEdges(src: "1", dst: "2") == 3)
        
    }
    
    func testJSON(){
      if let string = Files.loadFile(named: "new.json") {
        let data = string.data(using: .utf8)!
        do {
            if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? Dictionary<String,Any>
            {
                print(jsonArray) // use the json here
                let model = TTRBModel(json: jsonArray as! [String : [[String : Any]]])
                assert(model.getAllNodes().count == 4)
                assert(model.getAllEdges().count == 8)
            } else {
                print("bad json")
            }
        } catch let error as NSError {
            print(error)
        }
      } else {
        assertionFailure("Couldn't read file...")
      }
    }
    
    
    
}
