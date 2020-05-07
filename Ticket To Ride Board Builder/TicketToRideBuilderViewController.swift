//
//  ViewController.swift
//  Ticket To Ride Board Builder
//
//  Created by Dominic Chui on 5/5/20.
//  Copyright © 2020 CS326. All rights reserved.
//

import UIKit

private enum Mode {
    case addNode
    case addEdge
    case delete
    case move
}

class TicketToRideBuilderViewController: UIViewController,
                                         UIImagePickerControllerDelegate,
                                         UINavigationControllerDelegate {
    
    //Model
    
    private let model = TTRBModel()
    
    //View
        
    @IBOutlet weak var ttrbview: GraphView!
        
    private var mode = Mode.addNode
    
    private var counter = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    /*
      UIImagePickerControllerDelegate method to let user pick image.

      This method creates a new controller that pops up to get the
      user's choice.
    */
    func pickImage(_ sourceType : UIImagePickerController.SourceType) {
        print("OK")
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            print("IN")
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = sourceType
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
            print("OUT")
        }
    }

    /*
      Handler called when user has chosen an image.  Add code to do what you
      like with the picked image.
    */
    public func imagePickerController(_ picker: UIImagePickerController,
                  didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
     if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
       dismiss(animated:true, completion: nil)
      // TODO: do something with pickedImage here.
        ttrbview.background = pickedImage.resized(toFitIn: CGSize(width: 1024, height: 1024))
     }
    }

    @IBAction func AddNode(_ sender: UIButton) {
        mode = Mode.addNode
    }
    
    @IBAction func AddEdge(_ sender: UIButton) {
        mode = Mode.addEdge
    }
    
    @IBAction func Delete(_ sender: UIButton) {
        mode = Mode.delete
    }
    
    @IBAction func Move(_ sender: UIButton) {
        mode = Mode.move
    }
    
    @IBAction func Upload(_ sender: UIButton) {
        pickImage(.photoLibrary)
    }
    
    @IBAction func ScreenTapped(_ sender: UITapGestureRecognizer) {
        switch mode {
        case Mode.addNode:
            model.addNode(withName: String(counter), withLocation: sender.location(in: ttrbview))
        case Mode.addEdge:
            break
        case Mode.delete:
            break
        case Mode.move:
            break
        }
        print(mode)
    }
    
}

