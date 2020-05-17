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
    
    
    @IBAction func generateDestinationTicket(_ sender: UIButton) {
        //pick two nodes at random and ensure there is no edge between the two
        //use dijkstras to calculate minimum cost path (score)
        //update view with some sort of destination ticket/card
        //highlight starting node
        //start timer
    }
    
    //TODO: function to recognize tap on node (that has edge with highlighted node
        //if selected node is destination node, stop timer and report a success
    
    
}
