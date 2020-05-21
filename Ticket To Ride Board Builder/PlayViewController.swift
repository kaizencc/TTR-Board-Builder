//
//  PlayViewController.swift
//  Ticket To Ride Board Builder
//
//  Created by Kaizen Conroy on 5/17/20.
//  Copyright © 2020 CS326. All rights reserved.
//

import UIKit

class PlayViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "TTR Player"
        //hide all labels
        points.isHidden = true
        start.isHidden = true
        end.isHidden = true
        score.isHidden = true
        undoButton.isHidden = true
    }
    
    //Model
    // public, so we can set it in seque
    public var model : TTRBModel! {
        didSet {
            updateUI() // might happen before ttrbview is set!
        }
    }
    
    @IBOutlet weak var ttrbview: GraphView!{
        didSet {
            updateUI()  // might happen before model is set!
        }
    }
    
    
    // make ttrbview show the current model...
    func updateUI() {
        if model != nil && ttrbview != nil {  // ensure we have both model and view
            let nodes = model.getAllNodes()
            for node in nodes{
                ttrbview.items.append(GraphItem.node(loc: model.getLocation(forNode: node), name: node, highlighted: false))
            }
            // take all pairs of nodes, but if you process (src,dst), DON'T process (dst, src)...
            for i in 0..<nodes.count {
                for j in 0..<i {
                    let src = nodes[i]
                    let dst = nodes[j]
                    // find all edges src -> dst and given them unique similar values.
                    for (similar, edge) in model.getEdges(start: src, end: dst).enumerated() {
                        _ = addEdgeToView(similar, model.getLocation(forNode: edge.src), model.getLocation(forNode: edge.dst), routeColorToUIColor[edge.label.color]!)
                    }
                }
            }
        }
    }
    
    // Convert between model colors and view colors
    private let uiColorToRouteColor = [UIColor.red: Color.red,
                                       UIColor.green: Color.green,
                                       UIColor.blue: Color.blue,
                                       UIColor.yellow: Color.yellow,
                                       UIColor.purple: Color.purple,
                                       UIColor.black: Color.black,
                                       UIColor.white: Color.white,
                                       UIColor.orange: Color.orange,
                                       UIColor.gray: Color.gray]
    
    private let routeColorToUIColor = [Color.red: UIColor.red,
                                       Color.green: UIColor.green,
                                       Color.blue: UIColor.blue,
                                       Color.yellow: UIColor.yellow,
                                       Color.purple: UIColor.purple,
                                       Color.black: UIColor.black,
                                       Color.white: UIColor.white,
                                       Color.orange: UIColor.orange,
                                       Color.gray: UIColor.gray]
    

    //adds the edge to a view if 3 other paths do not already exist. returns true if successfully adds in edge.
    private func addEdgeToView(_ similar: Int, _ startPoint: CGPoint, _ endPoint: CGPoint, _ color: UIColor) -> Bool{
        if similar == 0{
            //add to view as dup.none
            ttrbview.items.append(GraphItem.edge(src: startPoint,
                                                 dst: endPoint,
                                                 label: String(model.calculateEdgeLength(start: startPoint, end: endPoint)),
                                                 highlighted: false,
                                                 color: color,
                                                 duplicate: dup.none))
            return true
        }
        else if similar == 1{
            //modify existing edge to be dup.left
            let modifyEdge = ttrbview.findSimilarEdge(src: startPoint, dst: endPoint)
            switch modifyEdge {
            case .node(_, _, _)?: break
            case .edge(let src, let dst, let label, let highlighted, let color, _)?:
                let newEdge = GraphItem.edge(src: src,
                                             dst: dst,
                                             label: label,
                                             highlighted: highlighted,
                                             color: color,
                                             duplicate: dup.left)
                let index = ttrbview.items.firstIndex(of: modifyEdge!)
                ttrbview.items.append(newEdge)
                ttrbview.items.remove(at: index!)
            default: break
            }
            //add to view as dup.right
            ttrbview.items.append(GraphItem.edge(src: startPoint,
                                                 dst: endPoint,
                                                 label: String(model.calculateEdgeLength(start: startPoint, end: endPoint)),
                                                 highlighted: false,
                                                 color: color,
                                                 duplicate: dup.right))
            return true
        }
        else if similar == 2{
            //add to view as dup.center
            ttrbview.items.append(GraphItem.edge(src: startPoint,
                                                 dst: endPoint,
                                                 label: String(model.calculateEdgeLength(start: startPoint, end: endPoint)),
                                                 highlighted: false,
                                                 color: color,
                                                 duplicate: dup.center))
            return true
        }
        //we don't allow more than 3 edges from same source to same destination
        return false
    }
    
    
    @IBOutlet weak var points: UILabel!
    
    @IBOutlet weak var start: UILabel!
    
    @IBOutlet weak var end: UILabel!
    
    @IBOutlet weak var score: UILabel!
    
    @IBOutlet weak var undoButton: UIButton!
    
    
    private var game = GameModel()
    
    @IBAction func generateDestinationTicket(_ sender: UIButton) {
        //make sure it is possible to generate ticket
        if model.getAllNodes().count <= 2{
            return
        }
        // if incomplete and starting over
        if game.inProgress && game.currentNode != nil{
            ttrbview.turnOffNodeHighlight(withLocation: model.getLocation(forNode: game.currentNode!))
        }
        // if complete, reset all variables
        if game.complete{
            unHighlightPath()
            //end node doesn't get unhighlighted in highlightPath()
            ttrbview.turnOffNodeHighlight(withLocation: model.getLocation(forNode: game.endNode!))
            game = GameModel()
        }
        //set to be in progress
        game.inProgress = true
        //pick two nodes at random and ensure there is no edge between the two
        var src = ""
        var dst = ""
        while true {
            src = model.randomNode()
            dst = model.randomNode()
            if src != dst && model.getEdges(start: src, end: dst).count == 0 {
                break
            }
        }
        //use dijkstras to calculate minimum cost path (score)
        let route = model.findMinCostPath(src: src, dst: dst)
        if route != nil {
            //update view with destination ticket/card
            points.isHidden = false
            points.text = "Goal:  " + String(route!.totalWeight)
            start.isHidden = false
            start.text = "Start: " + route!.edges.first!.src
            end.isHidden = false
            end.text = "End: " + route!.edges.last!.dst
            score.isHidden = false
            score.text = "Score: 0"
            undoButton.isHidden = false
            print(route!.totalWeight, route!.edges)
            
            //highlight starting node
            let startLocation = model.getLocation(forNode: route!.edges.first!.src)
            ttrbview.turnOnNodeHighlight(withLocation: startLocation)
            
            //update inner variables
            game.currentNode = route!.edges.first!.src
            game.endNode = route!.edges.last!.dst
            
            //start path
            game.updatePath()
        }
        //start timer
    }
    
    @IBAction func pickNode(_ sender: UITapGestureRecognizer) {
        if game.inProgress{
            let nextNode = ttrbview.findPoint(sender.location(in: ttrbview))
            
            if nextNode != nil && hasRouteBetween(start: game.currentNode!, end: model.getNodeName(withLocation: nextNode!)){
                let nextNodeName = model.getNodeName(withLocation: nextNode!)
                //turn off old highlight and turn on new one
                ttrbview.turnOnNodeHighlight(withLocation: nextNode!)
                ttrbview.turnOffNodeHighlight(withLocation: model.getLocation(forNode: game.currentNode!))
                
                //update score
                let edge = model.getEdges(start: game.currentNode!, end: nextNodeName).first
                game.currentScore += edge!.label.length
                score.text = "Score: " + String(game.currentScore)
                
                //update nodes
                game.currentNode = nextNodeName
                
                
                //update path
                game.updatePath()
                
            }
            if game.connected() {
                game.complete = true
                highlightPath()
                game.inProgress = false
            }
        }
    }
    
    private func hasRouteBetween(start src: String, end dst: String) -> Bool {
        let edges = model.getNodeEdges(start: src)
        for edge in edges{
            if edge.dst == dst{
                return true
            }
        }
        return false
    }
    
    private func highlightPath(){
        for i in 1..<game.path.count{
            let edge = model.getEdges(start: game.path[i-1], end: game.path[i]).first
            let start = model.getLocation(forNode: edge!.src)
            let end = model.getLocation(forNode: edge!.dst)
            ttrbview.turnOnEdgeHighlight(startPoint: start,
                                         endPoint: end)
            ttrbview.turnOnNodeHighlight(withLocation: start)
        }
    }
    
    private func unHighlightPath(){
        for i in 1..<game.path.count{
            let edge = model.getEdges(start: game.path[i-1], end: game.path[i]).first
            let start = model.getLocation(forNode: edge!.src)
            let end = model.getLocation(forNode: edge!.dst)
            ttrbview.turnOffEdgeHighlight(startPoint: start,
                                         endPoint: end)
            ttrbview.turnOffNodeHighlight(withLocation: start)
        }
    }
    
    @IBAction func undo(_ sender: UIButton) {
        if !game.complete && game.path.count > 1 {
            let current = game.currentNode!
            ttrbview.turnOffNodeHighlight(withLocation: model.getLocation(forNode: current))
            let previous = game.undo()
            ttrbview.turnOnNodeHighlight(withLocation: model.getLocation(forNode: previous))
            
            //update score
            let edge = model.getEdges(start: current, end: previous).first
            game.currentScore -= edge!.label.length
            score.text = "Score: " + String(game.currentScore)
        }
    }
    

   //if selected node is destination node, stop timer and report a success
    
    
}
