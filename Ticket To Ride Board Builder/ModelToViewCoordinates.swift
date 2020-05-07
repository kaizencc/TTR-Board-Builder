//
//  ModelToViewCoordinates.swift
//  ConnectTheDots
//
//  Created by freund on 9/6/18.
//  Copyright © 2018 Stephen Freund. All rights reserved.
//

import Foundation
import CoreGraphics

/**
 A structure to help us convert between two coordinate systems.
 Points in "Model Coordinates" are zoomed and shifted to
 produce points in "View Coordinates".
 
 The **abstract state** for a conversion is:
 
 * zoomScale: the scale facter when going from model to view.
 * viewoffset: where the original in model coordinates appears
 in view coordinates.
 
 **Abstraction Invariant**: zoomScale > 0
 
 */
public struct ModelToViewCoordinates {
  
  // The scale factor applied to Model Coordinates when
  // converting to View Coordinates
  let zoomScale: CGFloat
  
  // The point where the origin in Model Coordinates appears in
  // View Coordinates
  let viewOffset: CGPoint
  
  // Abstaction Function: AF(self):
  //    * zoomScale = self.zoomScale
  //    * viewOffset = self.viewOffset
  
  // Rep Invariant: RI(self): self.zoomScale > 0

  
  /// **Effects**: Fail fast if our rep invariant is not satisfied.
  private func checkRep() {
    assert(zoomScale > 0)
  }
  
  /**
   
   **Requires**: zoomScale > 0

   **Effects**: Creates a new ModelToViewCoordinates object with the
   given abstract state.
   
   */
  public init(zoomScale : CGFloat, viewOffset: CGPoint) {
    assert (zoomScale > 0)
    self.zoomScale = zoomScale
    self.viewOffset = viewOffset
    checkRep()
  }
  
  
  /**
   
   Create a transformation that maps the points inside the
   modelBounds rectangle to the greatest possible area inside
   of the viewBounds rectangle.  Examples:
   
       let b1 = CGRect(x: 0, y: 0, width: 400, height: 200)
       let b2 = CGRect(x: 0, y: 0, width: 200, height: 100)
   
       ModelToViewCoordinates(modelBounds: b1, viewBounds: b2)
       is the same as
       ModelToViewCoordinates(zoomScale: 0.5, viewOffset: CGPoint.zero)
   
       let b3 = CGRect(x: 0, y: 0, width: 200, height: 50)
   
       ModelToViewCoordinates(modelBounds: b1, viewBounds: b3)
       is the same as
       ModelToViewCoordinates(zoomScale: 0.25, viewOffset: CGPoint(x: 50, y: 0))
   
   
   **Requires**: modelBounds and viewBounds have width > 0 and height > 0.
   
   **Effects**: Creates a new ModelToViewCoordinates object with
   an abstract state that ensures all of modelBounds is within viewBounds.

   
   - Parameter modelBounds: A rectangle in model coordinates.
   - Parameter viewBounds: The rectangle in view coordinates that we wish
   to include all of the points in modelBounds.
   
   */
  public init(modelBounds : CGRect, viewBounds : CGRect)  {
    
    // We want either the height or width of the scaled modelBounds
    // to be exactly the height/width of viewBounds.  So,
    // scale will be set to the largest value such that:
    //   scale * modelBounds.width <= viewBounds.width and
    //   scale * modelBounds.height <= viewBounds.height.
    let scale = min(viewBounds.width / modelBounds.width,
                    viewBounds.height / modelBounds.height)
    
    
    // We want the center of the modelBounds to appear in the center of
    // viewBounds, so compute how far we need to move the scaled
    // modelBounds center so that it falls on the viewBound's center.
    let offset = CGPoint(x: (viewBounds.midX - modelBounds.midX * scale) ,
                         y: (viewBounds.midY - modelBounds.midY * scale))
    
    self.init(zoomScale: scale, viewOffset: offset)
  }
  
  /**
   - Parameter modelPoint: The location to convert, in model coordinates.
   - Returns: the modelPoint translated into view coordinates.
   */
  public func toView(modelPoint: CGPoint) -> CGPoint {
    return CGPoint(x: (modelPoint.x * zoomScale + viewOffset.x),
                   y: (modelPoint.y * zoomScale + viewOffset.y))
  }
  
  /**
   - Parameter viewPoint: The location to convert, in view coordinates.
   - Returns: the viewPoint translated into model coordinates.
   */
  public func fromView(viewPoint: CGPoint) -> CGPoint {
    return CGPoint(x: (viewPoint.x - viewOffset.x) / zoomScale,
                   y: (viewPoint.y - viewOffset.y) / zoomScale)
  }
  
  /**
   - Parameter by: How much to change the `zoomScale`
   - Returns: a new ModelToViewCoordinates with the same
   `viewOffset` but a scale of `self.zoomScale * amount`
   */
  public func scale(by amount: CGFloat) -> ModelToViewCoordinates {
    return ModelToViewCoordinates(zoomScale: zoomScale * amount,
                                  viewOffset: viewOffset)
  }
  
  /**
   - Parameter by: How much to change the `viewOffset`
   - Returns: a new ModelToViewCoordinates with the same
   `zoomScale` but a scale of
   `(viewOffset.x + amount.x, viewOffset.y + amount.y)`
   */
  public func shift(by amount: CGPoint) -> ModelToViewCoordinates {
    let newOffset = CGPoint(x: viewOffset.x + amount.x,
                            y: viewOffset.y + amount.y)
    return ModelToViewCoordinates(zoomScale: zoomScale,
                                  viewOffset: newOffset)
  }
}


