//
//  GameModel.swift
//  Ticket To Ride Board Builder
//
//  Created by Kaizen Conroy on 5/20/20.
//  Copyright © 2020 CS326. All rights reserved.
//

import Foundation


public class GameModel {
    //whether there is a current destination ticket displayed
    public var inProgress: Bool
    
    //what the current (highlighted) node is in the path
    public var currentNode: String?
    
    //what the last node in the path is
    public var endNode: String?
    
    //an array of nodes selected in the users path
    public var path: [String]
    
    //whether or not game is complete
    public var complete: Bool
    
    //what the current path cost is
    public var currentScore: Int
    
    public init(){
        inProgress = false
        currentNode = nil
        endNode = nil
        path = [String]()
        complete = false
        currentScore = 0
    }
    
    /**
    
    **Requires**: none
    
    **Modifies**: self
    
    **Effects**: adds a node to the path
        
    */
    public func updatePath(){
        path.append(currentNode!)
    }
    
    /**
    
    **Requires**: none
    
    **Modifies**: self
    
    **Effects**: removes a node from the path and updates currentNode
        
    */
    public func undo() -> String {
        path.removeLast()
        currentNode = path.last
        return currentNode!
    }
    
    /**
    
    **Requires**: none
    
    **Modifies**: self
    
    **Effects**: checks to see if destination is complete
        
    */
    public func connected() -> Bool {
        return currentNode == endNode
    }
}
