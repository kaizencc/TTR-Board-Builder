//
//  ImageViewController.swift
//

import UIKit


/// A general class to represent an image that may require some work to create
/// or load.  You create an ImageSource by passing to the initializer a
/// generating function, a closure that returns the UIImage of interest.
///
/// The generation function may do any work necessary to create the UIImage
/// object, and the ImageSource `image` property is lazy initialized with
/// the value returned from the generator the first time it is accessed.
///
/// The use case for URL images is thus the following:
///
///    ```
///    let url = URL(...)
///    let imageSource = ImageSource() {
///       if let urlContents = try? Data(contentsOf: url) {
///         return UIImage(data: urlContents)
///       } else {
///         return nil
///       }
///    }
///    ```
///
public class ImageSource : Equatable {
  
  /// the function used to generate the image when needed
  private let generator : () -> UIImage?
  
  /**
   Creates a new ImageSource that uses the provided generator
   to create the image.
   
   **Effects**: Creates the new image source.
   
   - Parameter generator: a function that returns a UIImage or nil,
   if a valid image cannot be created.  The generator will be called
   at most, and only when the image property is accessed.
   */
  public init(_ generator : @escaping () -> UIImage?) {
    self.generator = generator
  }
  
  /// The image we are provided.  Two notable aspects of the property:
  ///
  /// - It is lazy: We don't call generator() until the first time
  /// the property is accessed.
  ///
  /// - It is private(set): This is a publicly readable property, but
  /// we can only modify it within the class!
  ///
  private(set) public lazy var image : UIImage? = generator()
  
  /// - Returns: true iff lhs and rhs are the same object.
  public static func == (lhs: ImageSource, rhs: ImageSource) -> Bool {
    return lhs === rhs
  }
}


/// An ImageViewController presents an image within a UIScrollView.
/// The controller avoids blocking the UI thread by running the code to
/// get the UIImage to show on the global dispatch queue.
///
/// It also is able to handle images from sources other than a URL.  It supports
/// images from any source by have the client provide an ImageSource object rather
/// than a URL.  That object is responsible for providing an image when asked.
///
/// Given an imageViewController, the use case for URL images is the following:
///
///    ```
///    let url = URL(...)
///    let imageSource = ImageSource() {
///       if let urlContents = try? Data(contentsOf: url) {
///         return UIImage(data: urlContents)
///       } else {
///         return nil
///       }
///    }
///    imageViewController.imageSource = imageSource
///    ```
///
/// This version also extends the lecture version with:
///
/// * an action for sharing the shown image with other apps.
/// You may connect that handler to a UIBarButton in your UI.
///
/// * a spinng activity indicator that displays when getting
/// the image.  You may connect that handler to a UIActivityViewer.
///
public class ImageViewController : UIViewController, UIScrollViewDelegate {
  
  // MARK: Model!
  
  /**
   This generator object is used to create the image that will
   be displayed in the view.  The controller will generate the object
   via the global dispatch queue to avoid blocking the UI.
   */
  var imageSource : ImageSource? {
    didSet {
      image = nil
      if let imageProvider = imageSource {
        spinner?.startAnimating()
        // The lazy image may block,
        // so we must dispatch that call off to a background queue.
        DispatchQueue.global().async { [weak self] in
          let image = self?.imageSource?.image
          // Now that we're back from blocking
          // just dispatch the UI stuff back to the main queue
          DispatchQueue.main.async {
            // Are we still even interested in this provider?
            if self?.imageSource == imageProvider {
              self?.image = image
            }
          }
        }
      }
    }
  }
  
  // MARK: The View!
  
  /// This version has a spinner that you can hook up to an
  /// activity indicator if you wish to show a spinning
  /// wheel while getting the image to show.
  @IBOutlet private weak var spinner: UIActivityIndicatorView!
  
  /// The view that actually shows the image
  private var imageView = UIImageView()
  
  /// The scroll view for the image
  @IBOutlet private weak var scrollView: UIScrollView! {
    didSet {
      // to zoom we have to handle viewForZooming(in scrollView:)
      scrollView.delegate = self
      // and we must set our minimum and maximum zoom scale
      scrollView.minimumZoomScale = 0.03
      scrollView.maximumZoomScale = 10.0
      // most important thing to set in UIScrollView is contentSize
      scrollView.contentSize = imageView.frame.size
      scrollView.addSubview(imageView)
    }
  }
  
  /// The image to display.  This is a computed property
  /// to aid in writing the other methods.
  private var image: UIImage? {
    set {
      // Be careful -- if image is set in a prepare() method
      // as part of a segue, our outlets will not be set
      // yet...
      
      // Reset zoom/offset before changing image
      scrollView?.zoomScale = 1
      scrollView?.contentOffset = CGPoint.zero
      
      imageView.image = newValue
      imageView.sizeToFit()
      scrollView?.contentSize = imageView.frame.size
      
      // We never want an image and a spinner at the same time, so stop
      // spinner whenever we assign to image.
      spinner?.stopAnimating()
    }
    get {
      return imageView.image
    }
  }
  
  /// If we are loading an image that has not appeared yet,
  /// start the spinner in case it is not already spinning.
  public override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    if (image == nil && imageSource != nil) {
      spinner?.startAnimating()
    }
  }
  
  /// Returns the view to scroll/zoom, ie the image's view
  public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    return imageView
  }
  
  /**
   Enable the user to share the current image with other applications.
   You can connect this action to a UIBarButton to enable this functionality.
   */
  @IBAction private func shareImage(_ sender: UIBarButtonItem) {
    if let img = imageView.image {
      //  Uncomment this to save a copy of image on device -- in the simulator you can access
      //  that file through the Finder.
      //      if let data = UIImagePNGRepresentation(img) {
      //        let filename = FileManager.default.urls(for: .documentDirectory,
      //                                                in: .userDomainMask)[0].appendingPathComponent("copy.png")
      //        print("Shared image can be found at: \(filename)")
      //        try? data.write(to: filename)
      //      }
      
      let activityViewController = UIActivityViewController(activityItems: [img],
                                                            applicationActivities: nil)
      activityViewController.popoverPresentationController?.sourceView = self.view
      activityViewController.popoverPresentationController?.barButtonItem = sender
      self.present(activityViewController, animated: true,
                   completion: nil)
    }
  }
}

