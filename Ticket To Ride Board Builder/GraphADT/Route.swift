//
//  Route.swift
//  Ticket To Ride Board Builder
//
//  Created by Dominic Chui on 5/12/20.
//  Copyright © 2020 CS326. All rights reserved.
//

import Foundation

//contains the data for a route between two locations in TTR

public enum Color {
    case red
    case green
    case blue
    case yellow
    case purple
    case black
    case white
    case orange
    case gray
}

public struct Route: Comparable, Equatable {
    
    public let length: Int
    public let color: Color
    
    public init(withLength length: Int, withColor color: Color) {
        self.length = length
        self.color = color
    }
    
    public static func < (lhs: Route, rhs: Route) -> Bool {
        return lhs.length < rhs.length
    }
    
    
    public static func == (lhs: Route, rhs: Route) -> Bool {
        return lhs.length == rhs.length && lhs.color == rhs.color
    }
    
}
