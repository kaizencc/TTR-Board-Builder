//
//  PhotoCollection.swift
//  PhotoMosaic
//
//  Created by freund on 5/6/18.
//  Copyright © 2018 Stephen Freund. All rights reserved.
//

import Foundation
import UIKit


/**
 A PhotoCollection represents a group of Photos that are all the same size.
 Collections are stored in a folder in the app bundle and loaded by the
 static methods provided in this class.  A PhotoCollection is a sequence.
 Thus you can iterator over collections.  Example:
 
 ```
 // get names of all folders in "Photo Collections"
 let collectionNames = PhotoCollection.namesOfCollections(inFolder: "Photo Collections")
 
 // create collection for "swatches" subfolder and iterate over the photos
 // in that collection
 let collection = PhotoCollection.collection(named: "swatches", inFolder: "Photo Collections")
 for photo in collection {
   ...
 }
 ```
 
 **Specification Properties**:
 - name : String - The name of the collection
 - self : Sequence - The photos in the collecton
 - photoSize : Size - the size of each photo
 
 **Abstract Invariant**:
 - all photos stored in the collection has size photoSize.
 */
public class PhotoCollection : Sequence {
  /// Name of the collection
  public let name : String
  
  /// Photos in the collection
  private let photos : [Photo]
  
  /// size of each photo in collection
  public let photoSize : Size
  
  // Representation Invariant:
  //  - all photos must have size photoSize
  
  private func checkRep() {
    for photo in photos {
      assert (photo.size == photoSize)
    }
  }
  
  /**
   Create a new PhotoCollection with the given name and photos.
   
   **Requres**: photos.count > 0
   
   **Effects**: Createa a new object w/ the givven properties.
   
   - Parameter name: Name of the collection.
   - Parameter photos: The photos in the collection.
   
   */
  public init(name : String, photos : [Photo]) {
    self.name = name
    self.photos = photos
    self.photoSize = photos[0].size
    checkRep()
  }
  
  /// Return an iterator for the collections
  public func makeIterator() -> IndexingIterator<[Photo]> {
    return photos.makeIterator()
  }
  
  /**
   Find a photo with the given name in the collection.
   
   - Parameter name: The photo name to look for.
   - Returns: A photo with that name or nil if no such photo exists.
   */
  public func photo(named name: String) -> Photo? {
    return photos.first(where: { $0.name == name })
  }
  
  /**
   An image showing all of the photos in the
   collection, arranged in a grid.  This is useful to verify that collections
   are loading correctly and to see what images the contains.
   
   - Note: This may be computation expensive and should not run on
   the main UI thread.
   
   */
  public var image : UIImage {
    // Compute a height of the photo matrix that is closest
    // to making the matrix be square. If we can't get one close,
    // just return something close and expect there to be black space
    // at the bottom.
    func heightClosestToSquare(n : Int) -> Int {
      let sqRoot = Int(sqrt(Double(n)))
      for i in stride(from: sqRoot, through: Swift.max(2, sqRoot/2), by: -1) {
        if n % i == 0 {
          return i
        }
      }
      return sqRoot
    }
    
    let count = photos.count
    let rows = heightClosestToSquare(n: count)
    // adjust if we don't have a perfect rectangle of photos.
    let columns = (count % rows) == 0 ? (count / rows) : (count / rows + 1)
    let grid = PhotoMatrix(columns: columns, rows: rows, tileSize: photoSize)
    for i in 0..<photos.count {
      let row = i / columns
      let column = i % columns
      grid[column,row] = photos[i]
    }
    return grid.image
  }
  
  // internal cache to avoid reloading collections
  static private var cache : [String:PhotoCollection] = [:]
  
  /**
   
   Return a list of collection names, based on the folders found on the given path.
   
   The path is relative to the root of the resources for the main bundle of the app.  Use the
   optional bundle parameter to specify looking in the resources for a different bundle.
   
   Examples:
   1. To get the collections in the main bundles "Photo Collections" folder, include the
   following in any method also belonging to the main bundle:
   
   ```
   if let names = PhotoCollection.namesOfCollections(inFolder: "Photo Collections") {
   ...
   }
   ```
   
   2. To get the collections in the "Photo Collections" folder stored in the
   bundle for the "PhotoMosaicTests.swift" unit tests, include the following in a method
   of the `PhotoMosaicTests` class.
   
   ```
   if let names = PhotoCollection.namesOfCollections(inFolder: "Photo Collections",
   inBundle: Bundle(for: type(of: self))) {
   ...
   }
   ```
   
   - Parameter path: folder relative to the root of the resouces folder for `bundle` in
   which to look for collections.
   - Parameter bundle: The bundle in which to look.  Default: Bundle.main
   
   - Returns: An array of collection names, or nil if the path/bundle are invalid.
   
   */
  static public func namesOfCollections(inFolder path: String, inBundle bundle : Bundle = Bundle.main) -> [String]? {
    let docsPath = bundle.resourcePath! + "/" + path
    return try? FileManager.default.contentsOfDirectory(atPath: docsPath)
  }
  
  
  /**
   
   Create and return a collection with the given name at the given path.
   
   The path is relative to the root of the resources for the main bundle of the app.  Use the
   optional bundle parameter to specify looking in the resources for a different bundle.
   
   Examples:
   1. To get the collection of photos in the directory "Photo Collections/swatches" in
   the main bundles, include the
   following in any method also belonging to the main bundle:
   
   ```
   if let collection = PhotoCollection.collection(named: "swatches",
   inFolder: "Photo Collections") {
   ...
   }
   ```
   
   2. To get the collection of photos in the directory "Photo Collections/swatches-small" in the
   bundle for the "PhotoMosaicTests.swift" unit tests, include the following in a method
   of the `PhotoMosaicTests` class:
   
   ```
   if let collection = PhotoCollection.collection(named: "swatches",
   inFolder: "Photo Collections",
   inBundle: Bundle(for: type(of: self))) {
   ...
   }
   ```
   
   - Parameter name: Name of the folder inside the folder at path to use as the collection.
   - Parameter path: folder relative to the root of the resouces folder for `bundle` in
   which to look for collections.
   - Parameter bundle: The bundle in which to look.  Default: Bundle.main
   
   - Returns: A PhotoCollection of photos stored in the folder path/name inside the given bundle, or
   nil if not such path/name exists in the bundle
   
   */
  static public func collection(named name: String, inFolder path: String, inBundle bundle : Bundle = Bundle.main) -> PhotoCollection? {
    let collectionPath = bundle.resourcePath! + "/" + path + "/" + name
    if !FileManager.default.fileExists(atPath: collectionPath) {
      return nil
    } else {
      if let collection = cache[collectionPath] {
        return collection
      } else {
        let files = bundle.paths(forResourcesOfType: nil, inDirectory: path + "/" + name)
        
        let photos = files.map { (file:String) -> Photo in
          let name = (file as NSString).lastPathComponent
          let image = UIImage(contentsOfFile: file)
          assert(image != nil, "Bad image: \(name)")
          return Photo(image!, named: name)
        }
        
        let collection = PhotoCollection(name: name, photos: photos)
        cache[collectionPath] = collection
        return collection
      }
    }
  }
  
  
  
}


