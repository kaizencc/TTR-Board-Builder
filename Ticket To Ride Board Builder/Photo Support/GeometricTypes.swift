//
//  GeometricTypes.swift
//  PhotoMosaic
//
//  Created by freund on 5/6/18.
//  Copyright © 2018 Stephen Freund. All rights reserved.
//

import Foundation

/**
 A structure that contains a point in a
 two-dimensional integer coordinate system.
 */
public struct Point : CustomStringConvertible, Equatable {
  
  /// The x-coordinate of the point.
  public let x : Int
  
  /// The y-coordinate of the point.
  public let y : Int
  
  /// A textual representation of the point's coordinate values.
  public var description: String {
    return "(\(x), \(y))"
  }
  
  /// The point with location (0,0).
  public static let zero = Point(x: 0, y: 0)
}

/**
 A structure that contains integer width and height values.
 */
public struct Size : CustomStringConvertible, Equatable {
  
  /// The width of the size.
  public let width : Int
  
  /// The height of the size.
  public let height : Int
  
  /// A textual representation of the size.
  public var description: String {
    return "(\(width), \(height))"
  }
  
  /// The size whose width and height are both zero.
  public static let zero = Size(width: 0, height: 0)
}

/**
 A structure that contains integer location and dimensions
 of a rectangle.  For our purposes, the the origin is in
 the upper-left corner and the rectangle extends towards
 the lower-right corner
 */
public struct Rect : CustomStringConvertible, Equatable {
  
  /// A point that specifies the coordinates of the
  /// rectangle’s origin.
  public let origin : Point
  
  /// A size that specifies the height and width of the rectangle.
  public let size : Size
  
  /// Returns the width of a rectangle.
  public var width : Int { return size.width }
  
  /// Returns the height of a rectangle.
  public var height : Int { return size.height }
  
  /// Returns the smallest value for the x-coordinate of the rectangle.
  public var minX : Int { return origin.x }
  
  /// Returns the smallest value for the y-coordinate of the rectangle.
  public var minY : Int { return origin.y }
  
  /// Returns the x- coordinate that establishes the center of a rectangle.
  public var midX : Int { return origin.x + size.width / 2 }
  
  /// Returns the y-coordinate that establishes the center of the rectangle.
  public var midY : Int { return origin.y + size.height / 2 }
  
  /// Returns the largest value of the x-coordinate for the rectangle.
  public var maxX : Int { return origin.x + size.width }
  
  /// Returns the largest value for the y-coordinate of the rectangle.
  public var maxY : Int { return origin.y + size.height }
  
  /// A textual representation of the rectangle's origin and size values.
  public var description: String {
    return "(\(minX), \(minY), \(width), \(height)"
  }
  
  /// Creates a rectangle with the specified origin and size.
  public init(origin : Point, size : Size) {
    self.origin = origin
    self.size = size
  }
  
  /// Creates a rectangle with coordinates and dimensions
  /// specified as floating-point values.
  public init(x: Int, y: Int, width: Int, height: Int) {
    origin = Point(x: x, y: y)
    size = Size(width: width, height: height)
  }
  
  /// Returns whether the rectangle contains the point.
  public func contains(_ loc : Point) -> Bool {
    return minX <= loc.x && maxX >= loc.x
      && minY <= loc.y && maxY >= loc.y
  }

  /// Returns whether the rectangle contains the other
  /// rectangle.
  public func contains(_ other : Rect) -> Bool {
    return minX <= other.minX && maxX >= other.maxX
      && minY <= other.minY && maxY >= other.maxY
  }

  /// The rectangle whose origin and size are both zero.
  public static let zero = Rect(x: 0, y: 0, width: 0, height: 0)
  
}
