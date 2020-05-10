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
    
    private var startPoint: CGPoint? = nil
    
    private var movePoint: CGPoint? = nil
    
    
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
            newItems.append(GraphItem.node(loc: sender.location(in: ttrbview), name: String(nCounter), highlighted: false))
            ttrbview.items = newItems
            nCounter = nCounter + 1
        case Mode.addEdge:
            
            // if we have not initialized a starting point
            if startPoint == nil {
                if ttrbview.findPoint(sender.location(in: ttrbview)) != nil {
                    startPoint = ttrbview.findPoint(sender.location(in: ttrbview))!
                    ttrbview.switchHighlight(withLocation: startPoint!)
                }
            }
            // if we've already initialized a starting point
            else{
                let endPoint = ttrbview.findPoint(sender.location(in: ttrbview))
                if endPoint != nil && endPoint != startPoint{
                    
                    //add to view
                    var newItems = ttrbview.items
                    newItems.append(GraphItem.edge(src: startPoint!, dst: endPoint!, label: String(0), highlighted: false))
                    ttrbview.items = newItems
                    
                    //add to model
                    //find name of start node
                    let startName = model.getNodeName(withLocation: startPoint!)
                    //find name of end node
                    let endName = model.getNodeName(withLocation: ttrbview.findPoint(sender.location(in: ttrbview))!)
                    let edge = Edge(from: startName, to: endName, withLabel: 0)
                    model.addEdge(withEdge: edge)
                    
                    //sorta verifies it works lmao
                    model.printGraph()
                }
                ttrbview.switchHighlight(withLocation: startPoint!)
                //reset startNode
                startPoint = nil
            }

        case Mode.delete:
            //how do we delete edges? bonus
            //delete nodes + connected edges
            if let targetPoint = ttrbview.findPoint(sender.location(in: ttrbview)){
                //deleting all connected edges
                let targetName = model.getNodeName(withLocation: targetPoint)
                let edges = model.getAllEdges().filter( {$0.src == targetName || $0.dst == targetName })
                for edge in edges{
                    //delete from view
                    let edgeSrc = model.getLocation(forNode: edge.src)
                    let edgeDst = model.getLocation(forNode: edge.dst)
                    var toBeDeletedEdges = [Int]()
                    for i in 0..<ttrbview.items.count{
                        switch ttrbview.items[i]{
                        case .node:
                            break
                        case .edge(let src, let dst, _, _):
                            print(edgeSrc, edgeDst, src, dst)
                            if src == edgeSrc && dst == edgeDst {
                                toBeDeletedEdges.append(i)
                            }
                        }
                    }
                    //so we can delete multiple edges
                    for i in toBeDeletedEdges{
                        ttrbview.items.remove(at: i)
                    }
                    //delete from model
                    model.removeEdge(withEdge: edge)
                }
                //deleting node
                model.removeNode(withName: targetName)
                var cont = true
                for i in 0..<ttrbview.items.count{
                    if cont == false{
                        break
                    }
                    switch ttrbview.items[i]{
                    case .node(let loc, _, _):
                        if targetPoint == loc {
                            ttrbview.items.remove(at: i)
                            cont = false
                        }
                    case .edge:
                        break
                    }
                }
                model.printGraph()
            }
        case Mode.move:
            //to move, user has to click and then reclick in the updated location
            if movePoint == nil {
                if let startPoint = ttrbview.findPoint(sender.location(in: ttrbview)){
                    movePoint = startPoint
                    ttrbview.switchHighlight(withLocation: startPoint)
                }
            } else {
                let endPoint = sender.location(in: ttrbview)
                //move node in model
                model.moveNode(withName: model.getNodeName(withLocation: movePoint!),
                               newLocation: endPoint)
                //move node + edges in view
                for i in 0..<ttrbview.items.count{
                    switch ttrbview.items[i]{
                    case .node(let loc, let name, let highlighted):
                        if loc == movePoint{
                            ttrbview.items[i] = GraphItem.node(loc: endPoint, name: name, highlighted: highlighted)
                        }
                    case .edge(let src, let dst, let label, let highlighted):
                        if src == movePoint{
                            ttrbview.items[i] = GraphItem.edge(src: endPoint, dst: dst, label: label, highlighted: highlighted)
                        }
                        if dst == movePoint{
                            ttrbview.items[i] = GraphItem.edge(src: src, dst: endPoint, label: label, highlighted: highlighted)
                        }
                    }
                }
                ttrbview.switchHighlight(withLocation: endPoint)
                movePoint = nil
            }
            
            
        }
        print(mode)
    }
    
}

