//
//  Files.swift
//

import UIKit

/**
 Utilities to read files out of the applicaton's bundle.
 */

public class Files {
  
  
  /**
   
   Loads a file stored in the app's bundles.  It will search
   each bundle, returning contents of the first matching file.
   Failures will report an error through a modal alert.
   
   - Parameter named: The name of the file to load
   
   - Returns: The contents of the file as a string, or Nil if the file
   does not exist.
   
   */
  
  static public func loadFile(named: String) -> String? {
    for bundle in Bundle.allBundles {
      if let url = bundle.url(forResource: named, withExtension: nil) {
        do {
          return try String(contentsOf: url)
        } catch let error  {
          Files.fail(error.localizedDescription)
        }
      }
    }
    Files.fail("File '\(named)' not found")
    return nil
  }
  
  /**
   
   Prompts the user to select a file from the app bundle that has
   the desired extension (eg: `json`, `txt`, etc.).  The `action`
   function is called with the name and contents of the selected file if
   one is chosen.  Failures will report an error through a modal
   alert.
   
   **Usage (inside a ViewController):**
   ```
   Files.chooseFile(withExtension: "json", forController: self, action: {
   (fileName: String, contents: String) in
   ...
   })
   ```
   **or with trailing closure notation:**
   ```
   Files.chooseFile(withExtension: "json", forController: self) {
   (fileName: String, contents: String) in
   ...
   }
   ```
   
   - Parameter withExtension: Extension of all files in bundle to chose from.
   eg: ".json", ".txt", ...
   
   - Parameter forController: the UIViewController initiating the request.
   
   - Parameter action:        The function to call when the user chooses a file.
   It is passed the name and contents of the chosen file.
   
   - Parameter fileName:      the name of the chosen file.
   
   - Parameter contents:      the contents of the chosen file as a string.
   
   */
  static public func chooseFile(withExtension: String,
                                forController controller: UIViewController,
                                action : @escaping (_ fileName: String, _ contents: String) -> Void) {
    
    let chooser = FileChooserViewController(forExtension: withExtension,
                                            handler: action)
    
    controller.present(chooser, animated: true, completion: nil)
    
  }
  
  /**
   A view controller to load a file from the application's bundle.  This
   view will find all files matching a given extension and present a modal
   alert to allow selection.
   
   ** Usage (inside another ViewController) **
   ```
   let chooser = FileChooserViewController(forExtension: "json") {
   (fileName: String, contents: String) in {
   print(contents) // or something better...
   }
   }
   self.present(loader, animated: true, completion: nil)
   ```
   */
  private class FileChooserViewController: UIAlertController {
    
    
    /**
     
     Initializes a file chooser.
     
     - Parameter forExtension: Extension of all files in bundle to chose from.
     Eg: ".json", ".txt", ...
     
     - Parameter handler:  The function to call when the user chooses a file.
     It is passed the name and contents of the chosen file.
     
     - Parameter fileName: the name of the chosen file.
     
     - Parameter contents: the contents of the chosen file as a string.
     
     */
    public convenience init(forExtension fileExtension: String,
                            handler : @escaping (_ fileName: String, _ contents: String) -> Void) {
      
      self.init(title: "Load File", message: nil, preferredStyle: .alert)
      
      let bundle = Bundle(for: FileChooserViewController.self)
      if let urls = bundle.urls(forResourcesWithExtension: fileExtension,
                                subdirectory: nil) {
        for url in urls.sorted(by: { $0.lastPathComponent < $1.lastPathComponent }) {
          let name = (url.lastPathComponent as NSString).deletingPathExtension
          let loadAction = UIAlertAction(title: name, style: .default) { _ in
            do {
              let data = try String(contentsOf: url)
              handler(name, data)
            } catch let error  {
              Files.fail(error.localizedDescription)
            }
          }
          addAction(loadAction)
        }
      }
      
      let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {
        (_) in
      }
      addAction(cancelAction)
      
    }
  }
  
  static fileprivate func fail(_ message: String) {
    let alert = UIAlertController(title: "Error",
                                  message: message,
                                  preferredStyle: UIAlertController.Style.alert)
    alert.addAction(UIAlertAction(title: "OK",
                                  style: UIAlertAction.Style.default,
                                  handler: nil))
    
    // Not great, but enables us to show error here,
    // rather than have the user handle it
    if let root = UIApplication.shared.delegate?.window??.rootViewController {
      root.present(alert, animated: true, completion: nil)
    }
  }
}
