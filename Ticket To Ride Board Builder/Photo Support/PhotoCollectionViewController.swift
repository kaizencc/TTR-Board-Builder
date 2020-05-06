//
//  PhotoCollectionViewController.swift
//  PhotoMosaics
//

import UIKit

/**
 
 A simple view controller that lets you view the images stored in
 the provided photo collections.  You may use this to look at the collections
 and as an example of how to load photo collections in your program.
 
 */
class PhotoCollectionViewController: ImageViewController {
  
  /// the name of the resource folder containing the photos
  static private let photoCollectionPath = "Photo Collections"
  
  
  @IBAction func chooseCollection(_ sender: UIBarButtonItem) {
    if let photoCollectionNames = PhotoCollection.namesOfCollections(inFolder: PhotoCollectionViewController.photoCollectionPath) {
      chooseItemFromList(photoCollectionNames, prompt: "Choose image collection") {
        self.load(collectionNamed: $0)
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    load(collectionNamed: "swatches")
  }
  
  private func load(collectionNamed collectionName: String) {
    self.imageSource =
      ImageSource() {
        let collection = PhotoCollection.collection(named: collectionName,
                               inFolder: PhotoCollectionViewController.photoCollectionPath)
        return collection?.image
    }
  }
}
