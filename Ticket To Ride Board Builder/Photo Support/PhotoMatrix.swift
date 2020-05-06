//
//  PhotoMatrix.swift
//  PhotoMosaic
//
//  Created by Stephen Freund on 5/15/18.
//  Copyright © 2018 Stephen Freund. All rights reserved.
//

import Foundation
import UIKit


/**
 A 2-d matrix of photos that can be rendered as a UIImage.
 
 **Specification Properties**:
 - photos[col,row]  : the possibly-nil photo stored at the given column and row.
 - columns : Int - the number of columns
 - rows    : Int - the nubmer of rows
 - tileSize : Size - the size to render each photo stored in the matrix
 
 **Abstract Invariant**:
 - all photos stored in the matrix must have size == tileSize.
 - For all photo, count[photo] == number of times photo appears in photos.
 
 */
public class PhotoMatrix {
  
  /// The internal storage for the matrix
  private var photos : [[Photo?]]
  
  /// Number of rows in the matrix
  public let rows: Int
  
  /// Number of columns in the matrix
  public let columns: Int
  
  /// The size of each photo in the matrix
  public let tileSize : Size
  
  /// Keep a count of how many times each Photo appears
  /// in the matrix.  This is useful for some possible
  /// extensions.
  private var histogram : [Photo:Int] = [:]
  
  // Abstraction Function:
  //  - all properties are derived from the analogous concrete properties.
  
  // Representation Invariant:
  //  - photos is a 2-d array of size columns x rows
  //  - histogram[photo] == # of times photo appears in photos
  
  
  /// **Effects**: None, unless rep invariant violated.
  private func checkRep() {
    // too expensive to use!
    // var computedHistogram = [Photo:Int]()
    // for column in 0..<columns {
    //   for row in 0..<rows {
    //     if let photo = self[column,row] {
    //       assert(photo.size == tileSize, "Bad photo size")
    //       computedHistogram[photo] = (computedHistogram[photo] ?? 0) + 1
    //     }
    //   }
    // }
    // assert (computedHistogram == histogram, "Bad internal histogram")
  }
  
  /**
   Create a new PhotoMatrix with the given parameters.
   
   **Effects**: Creates a new PhotoMatrix w/ the given properties.
   
   */
  public init(columns: Int, rows: Int, tileSize: Size) {
    self.columns = columns
    self.rows = rows
    self.tileSize = tileSize
    photos = [[Photo?]](repeating: [Photo?](repeating: nil, count: rows),
                        count: columns)
    checkRep()
  }
  
  /**
   Get/set the photo at the given column and row.
   
   **Requires**:
   - (column,row) must be in the bounds of the matrix, and
   - any photo stored in the matrix must have size == tileSize.
   */
  public subscript (column: Int, row: Int) -> Photo? {
    get {
      assert(0 <= column && column < columns, "column out of bounds")
      assert(0 <= row && row < rows, "column out of bounds")
      return photos[column][row]
    }
    set {
      assert(0 <= column && column < columns, "column out of bounds")
      assert(0 <= row && row < rows, "column out of bounds")
      
      assert(newValue == nil || newValue!.size == tileSize, "Bad photo size")

      checkRep()

      let oldValue = photos[column][row]
      if (oldValue != nil) {
        histogram[oldValue!] = histogram[oldValue!]! - 1
      }
      
      if (newValue != nil) {
        histogram[newValue!] = (histogram[newValue!] ?? 0) + 1
      }
      
      photos[column][row] = newValue

      checkRep()
    }
  }
  
  
  /**
   
   The photo matrix rendered as a UIImage.  Any empty matrix slots
   are left as black rectangles.
   
   - Note: This may be computation expensive and should not
   run on the main UI thread.
   
   */
  public var image : UIImage {
    checkRep()

    // create the graphics context with the right size pixel array
    let width = columns * tileSize.width
    let height = rows * tileSize.height
    var pixels = [Pixel](repeating: Pixel.black, count: width * height)
    let context = CGContext(data: &pixels,
                            width: width,
                            height: height,
                            bitsPerComponent: 8,
                            bytesPerRow: 4 * width,
                            space: CGColorSpaceCreateDeviceRGB(),
                            bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue)
    
    assert(context != nil, "Cannot create context for mosaic converstion")
    
    // for each column and row, copy over the pixels from the photo
    for column in 0..<columns {
      for row in 0..<rows {
        if let photo = self[column,row] {
          let left = column * tileSize.width
          let top = row * tileSize.height
          // (left, top) is where to place the top left corner of where to place photo
          for x in 0..<tileSize.width {
            for y in 0..<tileSize.height {
              pixels[left + x + (top + y) * width] = photo[x,y]
            }
          }
        }
      }
    }
    
    let cgImage = context!.makeImage()
    assert(cgImage != nil, "Cannot create image for context in mosaic conversion")
    
    return UIImage(cgImage: cgImage!)
  }
  
  
  /**
   Counts how many times a photo appears in the matrix.
   
   - Parameter photo: The photo to look for.
   - Returns: how many entries in the photos contains that photo.
   
   - Note: This is O(1).
   */
  public func count(of photo: Photo) -> Int {
    checkRep()

    return histogram[photo] ?? 0
  }
}


