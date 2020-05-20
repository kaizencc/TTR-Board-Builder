//
//  DrawableGraphExtension.swift
//  Ticket To Ride Board Builder
//
//  Created by Kaizen Conroy on 5/20/20.
//  Copyright © 2020 CS326. All rights reserved.
//

import Foundation
import CoreGraphics

extension DrawableGraph where N == String, E == Route {
    public convenience init(json : [String:[[String: Any]]]) {
        self.init()
        for nodes in json["nodes"]!{
            let node_name = nodes["name"] as! String
            let node_location = nodes["location"] as! (Double, Double)
            let node_point = CGPoint(x: node_location.0, y: node_location.1)
            self.addNode(withName: node_name, withLocation: node_point)
        }
        for edges in json["Edges"]!{
            let src = edges["src"] as! String
            let dst = edges["dst"] as! String
            let label = edges["label"] as! [String:Any]
            let color = label["color"] as! String
            let route = Route(withLength: label["length"] as! Int, withColor: findColor(color: color))
            let edge = Edge<String,Route>(from: src, to: dst, withLabel: route)
            self.addEdge(edge)
        }
    }
    
    private func findColor(color: String) -> Color{
        if color == "black"{
            return Color.black
        }
        if color == "white"{
            return Color.white
        }
        if color == "blue"{
            return Color.blue
        }
        if color == "red"{
            return Color.red
        }
        if color == "gray" || color == "grey"{
            return Color.gray
        }
        if color == "orange"{
            return Color.orange
        }
        if color == "green"{
            return Color.green
        }
        if color == "purple"{
            return Color.purple
        }
        if color == "yellow"{
            return Color.yellow
        }
        return Color.gray
    }
}
