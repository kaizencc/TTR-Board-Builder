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
    
    //color buttons
    @IBOutlet weak var red: UIButton!
    @IBOutlet weak var green: UIButton!
    @IBOutlet weak var blue: UIButton!
    @IBOutlet weak var yellow: UIButton!
    @IBOutlet weak var purple: UIButton!
    @IBOutlet weak var black: UIButton!
    @IBOutlet weak var white: UIButton!
    @IBOutlet weak var orange: UIButton!
    @IBOutlet weak var grey: UIButton!
    
    private var currentColor: UIColor = UIColor.gray
    
    private var mode = Mode.addNode
    
    private var nCounter = 0
    
    private var startPoint: CGPoint? = nil
    
    private var movePoint: CGPoint? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //set color buttons to be hidden initially
        hideAllColors()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //hides color button
    private func hideColor(_ button: UIButton!){
        button.isHidden = true
        button.backgroundColor = UIColor.clear
    }
    
    private func hideAllColors(){
        let allButtons = [red,green,blue,yellow,purple,black,white,orange,grey]
        for button in allButtons{
            hideColor(button)
        }
    }
    
    //unhides color button
    private func openColor(_ button: UIButton!, _ color: UIColor!){
        button.isHidden = false
        button.backgroundColor = color
    }
    
    private func openAllColors(){
        let allButtons = [red,green,blue,yellow,purple,black,white,orange,grey]
        let allColors = [UIColor.red, UIColor.green, UIColor.blue, UIColor.yellow, UIColor.purple, UIColor.black, UIColor.white, UIColor.orange, UIColor.gray]
        for i in 0..<allButtons.count{
            openColor(allButtons[i],allColors[i])
        }
    }
    
    // Convert between model colors and view colors
    private let uiColorToRouteColor = [UIColor.red: Color.red,
                                       UIColor.green: Color.green,
                                       UIColor.blue: Color.blue,
                                       UIColor.yellow: Color.yellow,
                                       UIColor.purple: Color.purple,
                                       UIColor.black: Color.black,
                                       UIColor.white: Color.white,
                                       UIColor.orange: Color.orange,
                                       UIColor.gray: Color.gray]
    
    private let routeColorToUIColor = [Color.red: UIColor.red,
                                       Color.green: UIColor.green,
                                       Color.blue: UIColor.blue,
                                       Color.yellow: UIColor.yellow,
                                       Color.purple: UIColor.purple,
                                       Color.black: UIColor.black,
                                       Color.white: UIColor.white,
                                       Color.orange: UIColor.orange,
                                       Color.gray: UIColor.gray]
    
    
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
            ttrbview.background = pickedImage.resized(toFitIn: CGSize(width: 0.5*UIScreen.main.bounds.width, height: 0.5*UIScreen.main.bounds.height))
        }
    }
    
    //calculates what the edge length should be after adding an edge or moving a point
    public func calculateEdgeLength(start src: CGPoint, end dst: CGPoint) -> Int{
        let distance = ttrbview.CGPointDistance(from: src, to: dst)
        print(distance)
        return Int(distance/100) + 1
    }
    
    //reset the startPoint highlight if needed
    private func resetStartPoint(){
        if startPoint != nil{
            ttrbview.switchHighlight(withLocation: startPoint!)
            startPoint = nil
        }
    }
    
    
    @IBAction func AddNode(_ sender: UIButton) {
        mode = Mode.addNode
        hideAllColors()
        resetStartPoint()
        
    }
    
    @IBAction func AddEdge(_ sender: UIButton) {
        mode = Mode.addEdge
        openAllColors()
        resetStartPoint()
    }
    
    @IBAction func Delete(_ sender: UIButton) {
        mode = Mode.delete
        hideAllColors()
        resetStartPoint()
    }
    
    @IBAction func Move(_ sender: UIButton) {
        mode = Mode.move
        hideAllColors()
        resetStartPoint()
    }
    
    @IBAction func Upload(_ sender: UIButton) {
        pickImage(.photoLibrary)
        hideAllColors()
        resetStartPoint()
    }
    
    @IBAction func Clear(_ sender: UIButton) {
        model.clearGraph()
        ttrbview.items = []
    }
    
    
    @IBAction func MakeRed(_ sender: UIButton) {
        currentColor = UIColor.red
    }
    
    @IBAction func MakeGreen(_ sender: UIButton) {
        currentColor = UIColor.green
    }
    
    @IBAction func MakeBlue(_ sender: UIButton) {
        currentColor = UIColor.blue
    }
    
    @IBAction func MakeYellow(_ sender: UIButton) {
        currentColor = UIColor.yellow
    }
    @IBAction func MakePurple(_ sender: UIButton) {
        currentColor = UIColor.purple
    }
    
    @IBAction func MakeBlack(_ sender: UIButton) {
        currentColor = UIColor.black
    }
    
    @IBAction func MakeWhite(_ sender: UIButton) {
        currentColor = UIColor.white
    }
    
    @IBAction func MakeOrange(_ sender: UIButton) {
        currentColor = UIColor.orange
    }
    
    @IBAction func MakeGray(_ sender: UIButton) {
        currentColor = UIColor.gray
    }
    
    //adds the edge to a view if 3 other paths do not already exist. returns true if successfully adds in edge.
    private func addEdgeToView(_ similar: Int, _ startPoint: CGPoint, _ endPoint: CGPoint) -> Bool{
        if similar == 0{
            //add to view as dup.none
            ttrbview.items.append(GraphItem.edge(src: startPoint,
                                                 dst: endPoint,
                                                 label: String(calculateEdgeLength(start: startPoint, end: endPoint)),
                                                 highlighted: false,
                                                 color: currentColor,
                                                 duplicate: dup.none))
            return true
        }
        else if similar == 1{
            //modify existing edge to be dup.left
            let modifyEdge = ttrbview.findSimilarEdge(src: startPoint, dst: endPoint)
            switch modifyEdge {
            case .node(_, _, _)?: break
            case .edge(let src, let dst, let label, let highlighted, let color, _)?:
                let newEdge = GraphItem.edge(src: src,
                                             dst: dst,
                                             label: label,
                                             highlighted: highlighted,
                                             color: color,
                                             duplicate: dup.left)
                let index = ttrbview.items.firstIndex(of: modifyEdge!)
                ttrbview.items.append(newEdge)
                ttrbview.items.remove(at: index!)
            default: break
            }
            //add to view as dup.right
            ttrbview.items.append(GraphItem.edge(src: startPoint,
                                                 dst: endPoint,
                                                 label: String(calculateEdgeLength(start: startPoint, end: endPoint)),
                                                 highlighted: false,
                                                 color: currentColor,
                                                 duplicate: dup.right))
            return true
        }
        else if similar == 2{
            //add to view as dup.center
            ttrbview.items.append(GraphItem.edge(src: startPoint,
                                                 dst: endPoint,
                                                 label: String(calculateEdgeLength(start: startPoint, end: endPoint)),
                                                 highlighted: false,
                                                 color: currentColor,
                                                 duplicate: dup.center))
            return true
        }
        //we don't allow more than 3 edges from same source to same destination
        return false
    }
    
    private func addNode(nodeName node: String, withLocation point: CGPoint){
        //add to model, transform tapped point to model coordinates
        model.addNode(withName: node, withLocation: point)
        //add to view
        ttrbview.items.append(GraphItem.node(loc: point, name: node, highlighted: false))
    }
    
    private func deleteFromView(_ similar: Int, src: CGPoint, dst: CGPoint, color: UIColor, duplicate: dup){
        if duplicate == dup.center || duplicate == dup.none{
            let removal = ttrbview.findEdge(src: src, dst: dst, duplicate: duplicate)
            let index = ttrbview.items.firstIndex(of: removal!)!
            ttrbview.items.remove(at: index)
        }
        else if duplicate == dup.left{
            if similar == 2{
                //update dup.right to dup.none
                //find other edge to modify
                let modify = ttrbview.findEdge(src: src, dst: dst, duplicate: dup.right)!
                //find original edge to remove
                let removal = ttrbview.findEdge(src: src, dst: dst, duplicate: duplicate)!
                switch modify{
                case .node: break
                case .edge(let s, let d, let l, let h, let c, _):
                    let newEdge = GraphItem.edge(src: s, dst: d, label: l, highlighted: h, color: c, duplicate: dup.none)
                    //remove modify and removal, and add in newEdge
                    let index1 = ttrbview.items.firstIndex(of: removal)!
                    ttrbview.items.remove(at: index1)
                    let index2 = ttrbview.items.firstIndex(of: modify)!
                    ttrbview.items.remove(at: index2)
                    ttrbview.items.append(newEdge)
                }
                
            }
            if similar == 3{
                //update dup.center to dup.left
                //find other edge to modify
                let modify = ttrbview.findEdge(src: src, dst: dst, duplicate: dup.center)!
                //find original edge to remove
                let removal = ttrbview.findEdge(src: src, dst: dst, duplicate: duplicate)!
                switch modify{
                case .node: break
                case .edge(let s, let d, let l, let h, let c, _):
                    let newEdge = GraphItem.edge(src: s, dst: d, label: l, highlighted: h, color: c, duplicate: dup.left)
                    //remove modify and removal, and add in newEdge
                    let index1 = ttrbview.items.firstIndex(of: removal)!
                    ttrbview.items.remove(at: index1)
                    let index2 = ttrbview.items.firstIndex(of: modify)!
                    ttrbview.items.remove(at: index2)
                    ttrbview.items.append(newEdge)
                }
            }
        }
        else if duplicate == dup.right{
            if similar == 2{
                //update dup.left to dup.none
                //find other edge to modify
                let modify = ttrbview.findEdge(src: src, dst: dst, duplicate: dup.left)!
                //find original edge to remove
                let removal = ttrbview.findEdge(src: src, dst: dst, duplicate: duplicate)!
                switch modify{
                case .node: break
                case .edge(let s, let d, let l, let h, let c, _):
                    let newEdge = GraphItem.edge(src: s, dst: d, label: l, highlighted: h, color: c, duplicate: dup.none)
                    //remove modify and removal, and add in newEdge
                    let index1 = ttrbview.items.firstIndex(of: removal)!
                    ttrbview.items.remove(at: index1)
                    let index2 = ttrbview.items.firstIndex(of: modify)!
                    ttrbview.items.remove(at: index2)
                    ttrbview.items.append(newEdge)
                }
            }
            if similar == 3{
                //update dup.center to dup.right
                //find other edge to modify
                let modify = ttrbview.findEdge(src: src, dst: dst, duplicate: dup.center)!
                //find original edge to remove
                let removal = ttrbview.findEdge(src: src, dst: dst, duplicate: duplicate)!
                switch modify{
                case .node: break
                case .edge(let s, let d, let l, let h, let c, _):
                    let newEdge = GraphItem.edge(src: s, dst: d, label: l, highlighted: h, color: c, duplicate: dup.right)
                    //remove modify and removal, and add in newEdge
                    let index1 = ttrbview.items.firstIndex(of: removal)!
                    ttrbview.items.remove(at: index1)
                    let index2 = ttrbview.items.firstIndex(of: modify)!
                    ttrbview.items.remove(at: index2)
                    ttrbview.items.append(newEdge)
                }
            }
        }
    }
    
    
    @IBAction func ScreenTapped(_ sender: UITapGestureRecognizer) {
        switch mode {
        case Mode.addNode:
            //finds the point to add a node at
            let point = ttrbview.unitTransform.fromView(viewPoint: sender.location(in: ttrbview))
            //new UIController to facilitate keyboard text
            let controller = UIAlertController(title: "Create New Node", message: nil, preferredStyle: .alert)
            controller.addTextField(configurationHandler: { $0.placeholder = "max 10 chars" })
            controller.addAction(UIAlertAction(title: "Done", style: .default) {
                _ in
                //requirements are that node name is between 1 and 10 characters inclusive
                if let nodeName = controller.textFields![0].text,
                    nodeName.count > 0, nodeName.count < 11{
                    self.addNode(nodeName: nodeName, withLocation: point)
                }
            })
            self.present(controller, animated: false, completion: nil )
            
            
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
                if endPoint != nil && endPoint != startPoint {
                    //find name of start node
                    let startName = model.getNodeName(withLocation: startPoint!)
                    //find name of end node
                    let endName = model.getNodeName(withLocation: endPoint!)
                    //find amount of similar edges in the model
                    let similar = model.numberOfSimilarEdges(src: startName, dst: endName)
                    //add edge to view and if it succeeds, adds to model
                    if addEdgeToView(similar, startPoint!, endPoint!) {
                        //add to model
                        let route = Route(withLength: calculateEdgeLength(start: startPoint!, end: endPoint!),
                                          withColor: uiColorToRouteColor[currentColor]!)
                        let edge = Edge(from: startName,
                                        to: endName,
                                        withLabel: route)
                        model.addEdge(withEdge: edge)
                    }                    
                    print(model)
                }
                ttrbview.switchHighlight(withLocation: startPoint!)
                //reset startNode
                startPoint = nil
            }
            
        case Mode.delete:
            //user clicks on a node -> delete nodes + connected edges
            if let targetPoint = ttrbview.findPoint(sender.location(in: ttrbview)) {
                //deleting all connected edges
                let targetName = model.getNodeName(withLocation: targetPoint)
                let edges = model.getAllEdges().filter( {$0.src == targetName || $0.dst == targetName })
                for edge in edges{
                    //delete from view
                    let edgeSrc = model.getLocation(forNode: edge.src)
                    let edgeDst = model.getLocation(forNode: edge.dst)
                    var newItems = [GraphItem]()
                    for i in 0..<ttrbview.items.count{
                        switch ttrbview.items[i]{
                        case .node:
                            newItems.append(ttrbview.items[i])
                        case .edge(let src, let dst, _, _, _, _):
                            print(edgeSrc, edgeDst, src, dst)
                            if src != edgeSrc || dst != edgeDst {
                                newItems.append(ttrbview.items[i])
                            }
                        }
                    }
                    ttrbview.items = newItems
                    //delete from model
                    model.removeEdge(withEdge: edge)
                }
                //deleting node
                model.removeNode(withName: targetName)
                var cont = true
                for i in 0..<ttrbview.items.count {
                    if cont == false{
                        break
                    }
                    switch ttrbview.items[i] {
                    case .node(let loc, _, _):
                        if targetPoint == loc {
                            ttrbview.items.remove(at: i)
                            cont = false
                        }
                    case .edge:
                        break
                    }
                }
                print(model)
            }
                //user clicks on an edge -> delete that edge only and updates other edges
            else if let targetPoint = ttrbview.findEdgefromCenter(centeredAt: sender.location(in: ttrbview)){
                switch targetPoint{
                case .node: break
                case .edge(let src, let dst, let label, _ , let color, let dup):
                    //delete from view
                    let similar = model.numberOfSimilarEdges(src: model.getNodeName(withLocation: src),
                                                             dst: model.getNodeName(withLocation: dst))
                    deleteFromView(similar, src: src, dst: dst, color: color, duplicate: dup)
                    
                    //delete from model
                    let remove = Edge(from: model.getNodeName(withLocation: src),
                                      to: model.getNodeName(withLocation: dst),
                                      withLabel: Route(withLength: Int(label)!, withColor: uiColorToRouteColor[color]!))
                    model.removeEdge(withEdge: remove)
                }
            }
        case Mode.move:
            //to move, user has to click and then reclick in the updated location
            if movePoint == nil {
                if let startPoint = ttrbview.findPoint(sender.location(in: ttrbview)) {
                    movePoint = startPoint
                    ttrbview.switchHighlight(withLocation: startPoint)
                }
            } else {
                //transform tapped point to model coordinates
                let endPoint = ttrbview.unitTransform.fromView(viewPoint: sender.location(in: ttrbview))
                
                //move node in model
                model.moveNode(withName: model.getNodeName(withLocation: movePoint!),
                               newLocation: endPoint)
                //move node + edges in view
                for i in 0..<ttrbview.items.count {
                    switch ttrbview.items[i]{
                    case .node(let loc, let name, let highlighted):
                        if loc == movePoint{
                            ttrbview.items[i] = GraphItem.node(loc: endPoint, name: name, highlighted: highlighted)
                        }
                    case .edge(let src, let dst, _, let highlighted, let color, let duplicate):
                        if src == movePoint{
                            ttrbview.items[i] = GraphItem.edge(src: endPoint,
                                                               dst: dst,
                                                               label: String(calculateEdgeLength(start: endPoint, end: dst)),
                                                               highlighted: highlighted,
                                                               color: color,
                                                               duplicate: duplicate)
                        }
                        if dst == movePoint{
                            ttrbview.items[i] = GraphItem.edge(src: src,
                                                               dst: endPoint,
                                                               label: String(calculateEdgeLength(start: src, end: endPoint)),
                                                               highlighted: highlighted,
                                                               color: color,
                                                               duplicate: duplicate)
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
