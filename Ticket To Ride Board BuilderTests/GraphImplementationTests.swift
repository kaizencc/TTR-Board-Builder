import XCTest
@testable import Ticket_To_Ride_Board_Builder

class GraphImplementationTests: XCTestCase {
    
    //CONSTANTS FOR TESTING
    
    let nodesOne = ["Moo"]
    
    let nodesTwo = ["Cow", "Moo"]
    let edgesForNodesTwo = [Edge(from: "Cow", to: "Moo", withLabel: "")]
    let edgesMultipleForNodesTwo = [Edge(from: "Cow", to: "Moo", withLabel: "a"),
                                    Edge(from: "Cow", to: "Moo", withLabel: "b"),
                                    Edge(from: "Cow", to: "Moo", withLabel: "c")]
    
    let nodesFour = ["Dog", "Cat", "Hog", "Rat"]
    let edgesForNodesFour = [Edge(from: "Dog", to: "Cat", withLabel: "Chase"),
                             Edge(from: "Dog", to: "Hog", withLabel: "Hunt"),
                             Edge(from: "Rat", to: "Rat", withLabel: "Huddle")]
    let nodesFive = ["Dog", "Cat", "Hog", "Rat", "Pig"]
    
    let intNodes = [1,2,3]
    
    let intEdges = [Edge(from: 1, to: 2, withLabel: 0),
                    Edge(from: 2, to: 3, withLabel: 0)]
    
    //INITIALIZATION
    
    func testEmptyInit() {
        let graph = Graph<String, String>()
        XCTAssert(graph.nodes.count == 0)
        XCTAssert(graph.edges.count == 0)
    }
    
    func testInitWithOneNode() {
        let graph = Graph<String, String>(nodes: nodesOne, edges: [])
        XCTAssert(graph.nodes.count == 1)
        XCTAssert(graph.edges.count == 0)
    }
    
    func testInitWithNodesAndEdges() {
        let graph = Graph<String, String>(nodes: nodesTwo, edges: edgesForNodesTwo)
        XCTAssert(graph.nodes.count == 2)
        XCTAssert(graph.edges.count == 1)
    }
    
    func testInitWithMoreNodesAndEdges() {
        let graph = Graph<String, String>(nodes: nodesFour, edges: edgesForNodesFour)
        XCTAssert(graph.nodes.count == 4)
        XCTAssert(graph.edges.count == 3)
    }
    
    func testInitWithInits() {
        let graph = Graph(nodes: intNodes, edges: intEdges)
        XCTAssert(graph.nodes.count == 3)
        XCTAssert(graph.edges.count == 2)
    }
    
    
    //PROPERTY GETTERS
    
    func testNodeGetter() {
        let graphOne = Graph(nodes: nodesTwo, edges: edgesForNodesTwo)
        XCTAssert(graphOne.nodes.contains("Moo"))
        XCTAssert(graphOne.nodes.contains("Cow"))
        let graphTwo = Graph<String,String>(nodes: nodesOne, edges: [])
        XCTAssert(graphTwo.nodes.contains("Moo"))
    }
    
    func testEdgesGetter() {
        let graphOne = Graph(nodes: nodesTwo, edges: edgesForNodesTwo)
        XCTAssert(graphOne.edges == edgesForNodesTwo)
        let graphTwo = Graph<String,String>(nodes: nodesOne, edges: [])
        XCTAssert(graphTwo.edges == [])
    }
    
    func testIntGetters() {
        let graph = Graph(nodes: intNodes, edges: intEdges)
        XCTAssert(Set(graph.nodes) == Set(intNodes))
        XCTAssert(graph.edges.contains(intEdges[0]))
        XCTAssert(graph.edges.contains(intEdges[1]))
    }
    
    
    //GETEDGES METHOD
    
    func testGetEdgesWithSrcDstOneEdge() {
        let graph = Graph(nodes: nodesFour, edges: edgesForNodesFour)
        XCTAssert(graph.getEdges(src: "Dog", dst: "Cat") == [Edge(from: "Dog", to: "Cat", withLabel: "Chase")])
    }
    
    func testGetEdgesWithSrcDstMultipleEdges() {
        let graph = Graph(nodes: nodesTwo, edges: edgesMultipleForNodesTwo)
        XCTAssert(graph.getEdges(src: "Cow", dst: "Moo") == edgesMultipleForNodesTwo)
    }
    
    func testGetEdgesWithSrcDstZeroEdges() {
        let graph = Graph(nodes: nodesFour, edges: edgesForNodesFour)
        XCTAssert(graph.getEdges(src: "Cat", dst: "Hog") == [])
    }
    
    func testGetEdgesWithOnlySrcOneEdge() {
        let graph = Graph(nodes: nodesFour, edges: edgesForNodesFour)
        XCTAssert(graph.getEdges(targetNode: "Rat") == [Edge(from: "Rat", to: "Rat", withLabel: "Huddle")])
    }
    
    func testGetEdgesWithOnlySrcMultipleEdges() {
        let graph = Graph(nodes: nodesTwo, edges: edgesMultipleForNodesTwo)
        XCTAssert(graph.getEdges(targetNode: "Cow") == edgesMultipleForNodesTwo)
    }
    
    func testGetEdgesWithOnlySrcZeroEdges() {
        let graph = Graph(nodes: nodesFive, edges: edgesForNodesFour)
        XCTAssert(graph.getEdges(targetNode: "Pig") == [])
    }
    
    
    //GETCHILDREN METHOD
    
    func testGetChildrenOneNode() {
        let graph = Graph(nodes: nodesTwo, edges: edgesForNodesTwo)
        XCTAssert(graph.getChildren(src: "Cow") == ["Moo"])
    }
    
    func testGetChildrenMultipleNodes() {
        let graph = Graph(nodes: nodesFour, edges: edgesForNodesFour)
        XCTAssert(graph.getChildren(src: "Dog").contains("Cat"))
        XCTAssert(graph.getChildren(src: "Dog").contains("Hog"))
    }
    
    func testGetChildrenZeroNodes() {
        let graph = Graph(nodes: nodesTwo, edges: edgesForNodesTwo)
        XCTAssert(graph.getChildren(src: "Moo") == [])
    }
    
    func testGetChildrenOneNodeManyEdges() {
        let graph = Graph(nodes: nodesTwo, edges: edgesMultipleForNodesTwo)
        XCTAssert(graph.getChildren(src: "Cow") == ["Moo"])
    }
    
    func testGetIntChildren() {
        let graph = Graph(nodes: intNodes, edges: intEdges)
        XCTAssert(graph.getChildren(src: 1) == [2])
    }
    
    
    //CONTAINS METHOD
    
    func testContains() {
        let graph = Graph(nodes: nodesTwo, edges: edgesForNodesTwo)
        XCTAssert(graph.contains(node: "Cow"))
        XCTAssert(!graph.contains(node: "Dog"))
    }
    
    
    //ADDNODE METHOD
    func testAddNewNodetoEmpty() {
        let graph = Graph<String, String>()
        graph.addNode(withName: "Bovine")
        XCTAssert(graph.contains(node: "Bovine"))
        XCTAssert(graph.nodes.count == 1)
        XCTAssert(graph.edges.count == 0)
    }
    
    func testAddNewNodetoGraphWithOneNode() {
        let graph = Graph<String,String>(nodes: nodesOne, edges: [])
        graph.addNode(withName: "Bovine")
        XCTAssert(graph.contains(node: "Bovine"))
        XCTAssert(graph.nodes.count == 2)
        XCTAssert(graph.edges.count == 0)
    }
    
    func testAddExistingNodetoGraphWithOneNode() {
        let graph = Graph<String,String>(nodes: nodesOne, edges: [])
        graph.addNode(withName: "Moo")
        XCTAssert(graph.contains(node: "Moo"))
        XCTAssert(graph.nodes.count == 1)
        XCTAssert(graph.edges.count == 0)
    }
    
    func testAddNewNodetoGraphWithTwoNodes() {
        let graph = Graph(nodes: nodesTwo, edges: edgesForNodesTwo)
        graph.addNode(withName: "Bovine")
        XCTAssert(graph.contains(node: "Bovine"))
        XCTAssert(graph.nodes.count == 3)
        XCTAssert(graph.edges.count == 1)
    }
    
    func testAddExistingNodetoGraphWithTwoNodes() {
        let graph = Graph(nodes: nodesTwo, edges: edgesForNodesTwo)
        graph.addNode(withName: "Moo")
        XCTAssert(graph.contains(node: "Moo"))
        XCTAssert(graph.nodes.count == 2)
        XCTAssert(graph.edges.count == 1)
    }
    
    func testAddIntNode() {
        let graph = Graph(nodes: intNodes, edges: intEdges)
        graph.addNode(withName: 4)
        XCTAssert(graph.contains(node: 4))
        XCTAssert(graph.nodes.count == 4)
        XCTAssert(graph.edges.count == 2)
    }
    
    
    //REMOVENODE METHOD
    
    func testRemoveNodeFromGraphWithOneNode() {
        let graph = Graph<String,String>(nodes: ["Cow"], edges: [])
        graph.removeNode(withName: "Cow")
        XCTAssert(!graph.contains(node: "Cow"))
        XCTAssert(graph.nodes.count == 0)
    }
    
    func testRemoveNodeFromGraphWithTwoNodes() {
        let graph = Graph<String,String>(nodes: nodesTwo, edges: [])
        graph.removeNode(withName: "Cow")
        XCTAssert(!graph.contains(node: "Cow"))
        XCTAssert(graph.nodes.count == 1)
    }
    
    func testRemoveNodeFromGraphWithNodesAndEdges() {
        let graph = Graph(nodes: nodesFour, edges: [Edge(from: "Dog", to: "Cat", withLabel: "Chase"),
                                                    Edge(from: "Dog", to: "Hog", withLabel: "Hunt")])
        graph.removeNode(withName: "Rat")
        XCTAssert(!graph.contains(node: "Rat"))
        XCTAssert(graph.nodes.count == 3)
        XCTAssert(graph.edges.count == 2)
    }
    
    func testRemoveIntNode() {
        let graph = Graph(nodes: intNodes, edges: intEdges)
        graph.addNode(withName: 4)
        graph.removeNode(withName: 4)
        XCTAssert(!graph.contains(node: 4))
        XCTAssert(graph.nodes.count == 3)
        XCTAssert(graph.edges.count == 2)
    }
    
    //ADDEDGE METHOD
    
    func testAddNewEdge() {
        let graph = Graph<String,String>(nodes: nodesTwo, edges: [])
        graph.addEdge(newEdge: Edge(from: "Cow", to: "Moo", withLabel: "test"))
        XCTAssert(graph.nodes.count == 2)
        XCTAssert(graph.edges.count == 1)
    }
    
    func testAddEdgeWithDifferentLabel() {
        let graph = Graph(nodes: nodesTwo, edges: edgesForNodesTwo)
        graph.addEdge(newEdge: Edge(from: "Cow", to: "Moo", withLabel: "test"))
        XCTAssert(graph.nodes.count == 2)
        XCTAssert(graph.edges.count == 2)
    }
    
    func testAddExistingEdge() {
        let graph = Graph(nodes: nodesTwo, edges: edgesForNodesTwo)
        graph.addEdge(newEdge: Edge(from: "Cow", to: "Moo", withLabel: ""))
        XCTAssert(graph.nodes.count == 2)
        XCTAssert(graph.edges.count == 2)
    }
    
    func testAddReverseEdge() {
        let graph = Graph(nodes: nodesTwo, edges: edgesForNodesTwo)
        graph.addEdge(newEdge: Edge(from: "Moo", to: "Cow", withLabel: ""))
        XCTAssert(graph.nodes.count == 2)
        XCTAssert(graph.edges.count == 2)
    }
    
    func testAddEdgeToNodeWithOneEdge() {
        let graph = Graph(nodes: nodesFour, edges: edgesForNodesFour)
        graph.addEdge(newEdge: Edge(from: "Rat", to: "Dog", withLabel: "Flees"))
        XCTAssert(graph.nodes.count == 4)
        XCTAssert(graph.edges.count == 4)
    }
    
    func testAddEdgeToNodeWithTwoEdges() {
        let graph = Graph(nodes: nodesFour, edges: edgesForNodesFour)
        graph.addEdge(newEdge: Edge(from: "Dog", to: "Rat", withLabel: "Ignores"))
        XCTAssert(graph.nodes.count == 4)
        XCTAssert(graph.edges.count == 4)
    }
    
    func testAddEdgeToNodeWithThreeEdges() {
        let graph = Graph(nodes: nodesTwo, edges: edgesMultipleForNodesTwo)
        graph.addEdge(newEdge: Edge(from: "Cow", to: "Moo", withLabel: "d"))
        XCTAssert(graph.nodes.count == 2)
        XCTAssert(graph.edges.count == 4)
    }
    
    func testAddIntEdge() {
        let graph = Graph(nodes: intNodes, edges: intEdges)
        graph.addEdge(newEdge: Edge(from: 3, to: 1, withLabel: 0))
        XCTAssert(graph.nodes.count == 3)
        XCTAssert(graph.edges.count == 3)
    }
    
    
    //REMOVEEDGE METHOD
    
    func testRemoveEdgeFromGraphWithOneEdge() {
        let graph = Graph(nodes: nodesTwo, edges: edgesForNodesTwo)
        graph.removeEdge(targetEdge: graph.edges[0])
        XCTAssert(graph.nodes.count == 2)
        XCTAssert(graph.edges.count == 0)
    }
    
    func testRemoveEdgeFromGraphWithManyEdges() {
        let graph = Graph(nodes: nodesFour, edges: edgesForNodesFour)
        graph.removeEdge(targetEdge: graph.edges[0])
        XCTAssert(graph.nodes.count == 4)
        XCTAssert(graph.edges.count == 2)
    }
    
    func testRemoveEdgeFromGraphWithManyEdgesFromOneNode() {
        let graph = Graph(nodes: nodesTwo, edges: edgesMultipleForNodesTwo)
        graph.removeEdge(targetEdge: graph.edges[0])
        XCTAssert(graph.nodes.count == 2)
        XCTAssert(graph.edges.count == 2)
    }
    
    func testRemoveIntEdge() {
        let graph = Graph(nodes: intNodes, edges: intEdges)
        graph.removeEdge(targetEdge: Edge(from: 1, to: 2, withLabel: 0))
        XCTAssert(graph.nodes.count == 3)
        XCTAssert(graph.edges.count == 1)
    }
    
}
