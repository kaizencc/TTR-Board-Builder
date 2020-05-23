//
//  UIExtensions
//  PhotoMosaics
//

import Foundation
import UIKit
import CoreGraphics


/**
 A UIImage extension to support resizing images.
 */
public extension UIImage {
  /// Returns a image that fills in newSize
  private func resizedImage(newSize: CGSize) -> UIImage? {
    
    if self.size == newSize {
      return self
    }
    
    UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
    self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
    let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return newImage
  }
  
  /**
   Returns a resized image that fits in newSize, keeping it's aspect ratio
   
   Note that the new image size is not newSize, but within it.
   
   - Parameter rectSize: the returned image will fit within this size.
   - Returns: an image with the same aspect ratio as the original,
   but that fits within rect size, or nil if it cannot create such an image
   */
    func resized(toFitIn newSize: CGSize) -> UIImage? {
    let widthFactor = size.width / newSize.width
    let heightFactor = size.height / newSize.height
  
    let resizeFactor = min(widthFactor, heightFactor)
    
    let newSize = CGSize(width: size.width/resizeFactor, height: size.height/resizeFactor)
    
    return resizedImage(newSize: newSize)
  }
}

extension UIView {

    // Using a function since `var image` might conflict with an existing variable
    // (like on `UIImageView`)
    func asImage() -> UIImage {
        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(bounds: bounds)
            return renderer.image { rendererContext in
                layer.render(in: rendererContext.cgContext)
            }
        } else {
            UIGraphicsBeginImageContext(self.frame.size)
            self.layer.render(in:UIGraphicsGetCurrentContext()!)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return UIImage(cgImage: image!.cgImage!)
        }
    }
}


