//
//  CGPointArrow.swift
//  GraphViz
//

import Foundation
import CoreGraphics
import UIKit


/**
 Creates a UIBezierPath representing an arrow.  Often the arrow connects
 two circles, and you may wish to avoid overlapping with those shapes.  So,
 this method actually starts drawing a specified distance away from `from`
 and ends the arrow a specified distance before reaching `to`, as illustrated
 below:
 
 ```
 +           ------------------->      +
 from                                  to
 ```
 
 The distance between `from` and the start of the arrow is `fromRadius`,
 and the distance between the end of the arrow and `to` is `toRadius`.  If
 both are 0, the arrow extends the full distance between the two points.
 
 **Requires**: fromRadius, toRadius, arrowHeadLength, arrowHeadWidth all >= 0
 
 - Parameter from: where to start the arrow
 - Parameter to: where to end the arrow
 
 - Parameter fromRadius: the distance between `from` and the start of the arrow.
 - Parameter toRadius: the distance between the end of the arrow and `to`.
 
 - Parameter arrowHeadLength: How long the arrowhead is in points.
 - Parameter arrowHeadWidth: How wide the base of the arrowhead is in points.
 
 - Returns: a path representing the arrow
 */
public func pathForArrow(from: CGPoint,
                         to: CGPoint,
                         fromRadius: CGFloat = 0.0,
                         toRadius: CGFloat = 0.0,
                         arrowHeadLength : CGFloat = 6.0,
                         arrowHeadWidth : CGFloat = 6.0) -> UIBezierPath {
  
  assert(fromRadius >= 0, "fromRadius must be >= 0")
  assert(toRadius >= 0, "toRadius must be >= 0")
  assert(arrowHeadLength >= 0, "arrowHeadLength must be >= 0")
  assert(arrowHeadWidth >= 0, "arrowHeadWidth must be >= 0")
  
  let cgPath = UIBezierPath()
  
  let distance = from.distance(to: to)
  if (distance - (fromRadius + toRadius) > 0.0) {
    let theta = from.angle(to: to)
    
    let tail = from.offset(by: CGVector(radius: fromRadius, angle: theta))
    let head = from.offset(by: CGVector(radius: from.distance(to: to) - toRadius,
                                        angle: theta))
    
    if (arrowHeadLength > 0) {
      cgPath.move(to: CGPoint(x: -arrowHeadLength, y: arrowHeadWidth/2))
      cgPath.addLine(to: CGPoint(x: -arrowHeadLength, y: arrowHeadWidth/2))
      cgPath.addLine(to: CGPoint(x: 0, y: 0))
      cgPath.addLine(to: CGPoint(x: -arrowHeadLength, y: -arrowHeadWidth/2))
      cgPath.close()
      
      let cosine: CGFloat = cos(theta)
      let sine: CGFloat = sin(theta)
      
      let transform = CGAffineTransform(a: cosine, b: sine,
                                        c: -sine, d: cosine,
                                        tx: head.x, ty: head.y)
      
      cgPath.apply(transform)
    }
    
    let endOfArrowShaft = head.offset(by: CGVector(radius: -arrowHeadLength,
                                                   angle: theta))
    cgPath.move(to: tail)
    cgPath.addLine(to: endOfArrowShaft)
    
  }
  return cgPath
}

///// Utility functions for the above

fileprivate extension CGVector {
  
  /**
   Create a new CGVector using a radius and angle indicating the
   magnitude of the vector and its direction.  The resulting
   vector is defined as:
   
   * dx = radius * cos(angle)
   * dy = radius * sin(angle)
   
   */
  init (radius: CGFloat, angle: CGFloat) {
    self.init(dx: radius * cos(angle), dy: radius * sin(angle))
  }
}

/// Utility functions for GraphViz
fileprivate extension CGPoint {
  
  /// - Returns: the distance to another point.
  func distance(to point: CGPoint) -> CGFloat {
    return hypot(point.x - x, point.y - y)
  }
  
  /// - Returns: the angle of a vector drawn between this
  ///      point and the parameter point.  The result is in
  ///      radians.
  func angle(to point: CGPoint) -> CGFloat {
    return atan2(point.y - y, point.x - x)
  }
  
  /// - Returns: a new point offset from self by the given amounts
  ///            in the x and y directions
  func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
    return CGPoint(x: x + dx, y: y + dy)
  }
  
  /// - Returns: a new point offset from self by the given vector.
  func offset(by vector : CGVector) -> CGPoint {
    return CGPoint(x: x + vector.dx, y: y + vector.dy)
  }
  
}


