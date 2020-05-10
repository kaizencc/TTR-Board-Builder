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
    
    private var nCounter = 0
    private var eCounter = 0
    
    private var startPoint = CGPoint.zero
    
    
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
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = sourceType
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
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
        
        //make the background the image
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
            //add to model
            model.addNode(withName: String(nCounter), withLocation: sender.location(in: ttrbview))
            //add to view
            var newItems = ttrbview.items
            newItems.append(GraphItem.node(loc: sender.location(in: ttrbview), name: String(nCounter), highlighted: true))
            ttrbview.items = newItems
            nCounter = nCounter + 1
        case Mode.addEdge:
            
            // if we have not initialized a starting point
            if startPoint == CGPoint.zero {
                if ttrbview.findPoint(sender.location(in: ttrbview)) != nil {
                    startPoint = ttrbview.findPoint(sender.location(in: ttrbview))!
                    //maybe we want to highlight the start point
                }
            }
            // if we've already initialized a starting point
            else{
                if ttrbview.findPoint(sender.location(in: ttrbview)) != nil {
                    
                    //add to view
                    var newItems = ttrbview.items
                    newItems.append(GraphItem.edge(src: startPoint, dst: sender.location(in: ttrbview), label: String(eCounter), highlighted: false))
                    ttrbview.items = newItems
                    
                    eCounter = eCounter + 1
                    
                    //add to model
                    //find name of start node
                    let startName = model.getNodeName(withLocation: startPoint)
                    //find name of end node
                    let endName = model.getNodeName(withLocation: ttrbview.findPoint(sender.location(in: ttrbview))!)
                    let edge = Edge(from: startName, to: endName, withLabel: 0)
                    model.addEdge(withEdge: edge)
                    
                    //sorta verifies it works lmao
                    model.printGraph()
                    
                    //reset startNode
                    startPoint = CGPoint.zero
                    
                }
            }
            break
        case Mode.delete:
            //how do we delete edges? 
            break
        case Mode.move:
            //do we want move to be a drag functionality or click and then reclick
//            if ttrbview.findPoint(sender.location(in: ttrbview)) != nil {
//            }
            break
        }
        print(mode)
    }
    
}

