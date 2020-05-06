//
//  Photo.swift
//  PhotoMosaic
//
//  Created by Stephen Freund on 5/1/18.
//  Copyright © 2018 Stephen Freund. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit


/**
 Represents the color intensities for one pixel in a Photo.
 
 **Abstract State**:
    - red, green, and blue channels
    - each is a value between 0..255
 
 This is an immutable struct.

 */
public struct Pixel : CustomStringConvertible {
  
  // Abstraction Function:
  //    - each spec property is based on the analogous concrete property.

  // Rep Invariant: None
  
  /// The intensity of red in the pixel's color (0-255)
  public let red   : UInt8
  
  /// The intensity of green in the pixel's color (0-255)
  public let green : UInt8
  
  /// The intensity of blue in the pixel's color (0-255)
  public let blue  : UInt8
  
  // The transparency of the pixel.  We'll ignore transparancies.
  private let alpha : UInt8 = 0
  
  /// A grayscale intensity for the pixel.
  public var intensity : UInt8 {
    // see https://en.wikipedia.org/wiki/Grayscale for how to convert
    // RGB values to grayscale intensities.
    return UInt8((0.2126 * Double(red) / 255
      + 0.7152 * Double(green) / 255
      + 0.0722 * Double(blue) / 255)*255)
  }
  
  /// A textual representation of the RGB channels
  public var description: String {
    return "[\(red), \(green), \(blue)]"
  }
  
  /// A pixel with all 0 intensities.
  public static let black = Pixel(red: 0,green: 0,blue: 0)
}


/**
 Represents an image in a way amenable to the processing we will do on them.
 
 **Specification Properties**:
   - image  : UIImage - the underlying image the photo captures
   - name   : String? - The optional name of the photo
   - size   : Size - the width and height of the photo
   - pixels   : [[Pixel]] - the photo is conceptually a 2d array of pixels
 
 **Abstract Invariant**:
   - size is the same as image.size, but truncated to integral dimensions.
   - pixels[x,y] is a Pixel with the same color as the image and point (x,y)
 
 This is an immutable class.
 
 */
public class Photo : Hashable, CustomStringConvertible  {
  /// Optional name for the image (possibly useful for debugging).
  public let name : String?
  
  /// The underlying image on which the Photo is based.
  public let image : UIImage
  
  /// Internal rep of pixel array.  We use a 1-d array rather than a 2-d array
  /// in order to leverage the underlying Core Graphics routines.
  private let oneDimensionalPixels: [Pixel]
  
  /// width and height of the photo.
  public let size : Size
  
  // Representation Invariant:
  //  - size is the same as image.size, but trancated to integral dimenaions
  //  - oneDimensionalPixels.count == size.width * size.height
  //  - oneDimensionalPixels[x + y * size.width] is the color of the pixel at (x,y) in image
  //
  
  // Abstraction Function:
  //  - pixels[x,y] = oneDimensionalPixels[x + y * size.width]
  
  /**
   Create a new photo for an image.
   
   - **Effects**: makes a new Photo for the image
   
   - Parameter image: the image for the photo
   - Parameter name: the optional name for the image (useful for debugging)
   */
  public init(_ image : UIImage, named name: String? = nil) {
    
    // images taken on a phone's camera may not be oriented properly, so
    // ensure that first.
    UIGraphicsBeginImageContext(image.size)
    image.draw(at: .zero)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    let reoriented = newImage ?? image
    self.image = reoriented
    self.name = name
    self.size = Size(width: Int(reoriented.size.width), height: Int(reoriented.size.height))
    let dataSize = size.width * size.height
    var pixels = [Pixel](repeating: Pixel.black, count: dataSize)
    let context = CGContext(data: &pixels,
                            width: size.width,
                            height: size.height,
                            bitsPerComponent: 8,
                            bytesPerRow: 4 * size.width,
                            space: CGColorSpaceCreateDeviceRGB(),
                            bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue)
    assert(context != nil, "Failed to make photo for image \(name ?? "")")
    let cgImage = reoriented.cgImage
    assert(cgImage != nil, "Failed to make photo for image \(name ?? "")")
    context!.draw(cgImage!, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
    self.oneDimensionalPixels = pixels
  }
  
  /// A PhotoSlice for the entire Photo.
  public var asSlice : PhotoSlice {
    return PhotoSlice(self, boundedBy: Rect(origin: Point.zero, size: size))
  }
  
  /// The Pixel value for (x,y).
  ///
  /// **Requires**: x,y must be within the bounds of the photo.
  public subscript (x: Int, y: Int) -> Pixel {
    get {
      assert(0 <= x && x < size.width, "x location out of bounds")
      assert(0 <= y && y < size.height, "y location out of bounds")
      return oneDimensionalPixels[x + y * size.width]
    }
  }
  
  public var description: String {
    return "Photo(\(image.description)"
  }
  
  public var hashValue: Int {
    return image.hashValue
  }
  
  public static func == (lhs: Photo, rhs: Photo) -> Bool {
    return lhs.image === rhs.image
  }
  

  
}

/**
 Represents a read-only view for on rectangular region of a Photo.
 
 The PhotoSlice enables fast and efficient read operations on sections of a large Photo without
 creating a copy of any of the underlying photo's pixel data.
 
 **Specification Properties**:
     - photo   : Photo - the underlying photo
     - bounds  : Rect - the sub-part of the photo we can access.
     - pixels   : [[Pixel]] - the photo is conceptually a 2d array of pixels

 **Abstract Invariant**:
     - pixels[x,y] == photo[x,y] for all (x,y) in bounds
 
 */
public class PhotoSlice : Equatable {
  
  /// The underlying photo -- we provide no access here to avoid mutations / copies
  fileprivate let photo : Photo
  
  /// The bounds of the part of the photo we can safely access.
  public let bounds : Rect
  
  // Representation Invariant:
  //  - bounds is contained within photo.bounds
  
  // Abstraction Function:
  //  - pixels[x,y] = photo[x, y] for all (x,y) in bounds
  //  - other spec properties are derived from the analogous fields.
  
  /// Create a new slice for the given photo and bounds.
  /// It is private -- you need to create slices by the subscripting operations
  /// of Photo and PhotoSlice.
  fileprivate init(_ photo : Photo, boundedBy bounds : Rect) {
    self.photo = photo
    assert(Rect(origin: .zero, size: photo.size).contains(bounds), "Bad slice bounds")
    self.bounds = bounds
  }
  
  /// Access photo[x,y].
  ///
  /// **Requires**: (x,y) in bounds.
  public subscript (x: Int, y: Int) -> Pixel {
    get {
      assert(bounds.contains(Point(x: x,y: y)), "Pixel location out of slice bounds")
      return photo[x,y]
    }
  }
  
  /// create a new Slice with the given bounds.
  ///
  /// **Requires**: sliceBounds must be within bounds.
  public subscript (sliceBounds: Rect) -> PhotoSlice {
    get {
      assert(bounds.contains(sliceBounds), "Bad slice bounds")
      return PhotoSlice(photo, boundedBy: sliceBounds)
    }
  }
  
  /**
    Two slices are equal if the are for the same Photo and have the same bounds.
 
     - Parameter lhs: the first photo
     - Parameter rhs: the second photo
     - Returns: true iff the two PhotoSlices represent the same slice.
   */
  public static func == (lhs: PhotoSlice, rhs: PhotoSlice) -> Bool {
    return lhs.photo === rhs.photo &&
      lhs.bounds == rhs.bounds
  }
  
  
}
