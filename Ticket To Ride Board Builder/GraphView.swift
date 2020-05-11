//
//  GraphItem.swift
//  ConnectTheDots
//
//  Created by freund on 9/6/18.
//  Copyright Â© 2018 Stephen Freund. All rights reserved.
//

import UIKit


/**
 A Custom View to display graphs.  In this version, nodes contains
 string labels and edges and undirected and unlabelled.  Both nodes
 and edges can be highlighted.
 
 Display a graph by setting GraphView.items to a list of `GraphItem`
 enum values describing the graph.  Inspectable properties enable
 you to customize how the graph is drawn.
 
 The GraphView class supports panning, zooming, and zooming in as far
 as possible via gesture recognizers that you must wire appropriately
 in XCode.
 
 */
@IBDesignable
public class GraphView: UIView {
    
    // MARK: Public Properties to Adjust Look
    
    
    /// A background image drawn behind the graph items.
    /// This image will be placed at (0,0) in model coordinates
    /// and scaled/offset according to the model-to-view conversion.
    @IBInspectable var background : UIImage? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// By default, edges are assumed to end at visible nodes
    /// and their arrows are shortened at both ends to ensure
    /// they don't overlap those nodes.  In some cases (eg:
    /// CampusPaths), we don't want this behavior.  Setting
    /// this property to false will turn that behavior off.
    @IBInspectable
    public var edgesWontOverlapNodes : Bool = true  {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// Radius of each node
    @IBInspectable
    public var nodeRadius : CGFloat = 10.0  {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// Color of node frame and edges
    @IBInspectable
    public var outlineColor : UIColor = UIColor.black  {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// Color of highlighted node or edge
    @IBInspectable
    public var outlineHighlightColor : UIColor = UIColor.red  {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// Color of node body
    @IBInspectable
    public var nodeColor : UIColor = UIColor.gray  {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// Color of node body when highlighted
    @IBInspectable
    public var nodeHighlightColor : UIColor = UIColor.yellow  {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// Size of edges
    @IBInspectable
    public var lineWidth : CGFloat = 8.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// Size of labels in nodes
    @IBInspectable
    public var textSize : CGFloat = 10.0  {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// Text color of labels in nodes
    @IBInspectable
    public var textColor : UIColor = UIColor.black  {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// Width of highlighted edges
    @IBInspectable
    public var highlightThickness : CGFloat = 3.0  {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // MARK: Public display list
    
    /// The items that are currently displayed in the view.  The order
    /// in the array reflects the order in which items are drawn.  Specifically
    /// items[0] is drawn first.
    public var items : [GraphItem] = [
//        GraphItem.node(loc: CGPoint(x: 100, y:100), name: "A", highlighted: true),
//        GraphItem.node(loc: CGPoint(x: 100, y:200), name: "B", highlighted: false),
//        GraphItem.edge(src: CGPoint(x: 100, y:100), dst: CGPoint(x:300, y:300), label: "Edge", highlighted: false),
//        GraphItem.edge(src: CGPoint(x: 300, y:100), dst: CGPoint(x:300, y:200), label: "Moo", highlighted: true)
        ] {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// The Zoom/Offset transform to convert from the graph item's model coordinates
    /// to the view's coordinates
    public var unitTransform = ModelToViewCoordinates(zoomScale: 1.0,
                                                       viewOffset: CGPoint.zero) {
        didSet {
            setNeedsDisplay()
        }
    }
    
    public func switchHighlight(withLocation loc: CGPoint){
        for i in 0..<items.count{
            switch items[i] {
            case .node(let location, let name, let highlight):
                if location == loc {
                    let new = GraphItem.node(loc: location, name: name, highlighted: !highlight )
                    items[i]=new
                }
            case .edge:
                break
            }
        }
    }
    
    // MARK: Coordinates
    
    /**
    Find the distance between two points in the view.
    
    **Effects**: None
    
    - Parameter from: the starting point
    - Parameter to: the ending point
     - Returns: the distance between the two points
    */
    public func CGPointDistance(from: CGPoint, to: CGPoint) -> CGFloat {
        return sqrt((from.x - to.x) * (from.x - to.x) + (from.y - to.y) * (from.y - to.y))
    }
    
    /**
     
     Tests whether a location in the view falls within the circle drawn for a node
     centered at the provided point.
     
     - Parameter point: View point of interest (in View Units)
     - Parameter nodeCenteredAt: The center of a node (in Model Units)
     - Returns: true iff the point is within the circle drawn for a node centered
     at the given node point.
     
     */
    public func pointIsInside(_ point: CGPoint, nodeCenteredAt centerInModelUnits: CGPoint) -> Bool {
        
        let centerInViewUnits = unitTransform.toView(modelPoint: centerInModelUnits)
        let dx = centerInViewUnits.x - point.x
        let dy = centerInViewUnits.y - point.y
        return sqrt(dx*dx + dy*dy) < nodeRadius
    }
    
//    public func pointIsInsideEdge(_ point: CGPoint, edgeSrc src: CGPoint, edgeDst dst: CGPoint) -> Bool {
//        //let rect = CGRect(
//        //return rect.contains(point)
//        return true
//    }
    
    /**
     
     Tests whether a location in the view falls within the circle drawn for all nodes
     already in the graph.
     
     - Parameter point: View point of interest (in View Units)
     - Returns: the node if it is found, nil otherwise
     
     */
    public func findPoint(_ point: CGPoint) -> CGPoint?{
        let nodes = nodePoints()
        for node in nodes{
            if pointIsInside(point, nodeCenteredAt: node){
                return node
            }
        }
        return nil
    }
    
    // MARK: Drawing
    
    /**
     
     Draw all of the items in the list of items.
     
     **Effects**: Draws all items to the view
     
     - Parameter rect: ignored for us.
     */
    override public func draw(_ rect: CGRect) {
        background?.draw(unitTransform: unitTransform, viewBounds: bounds)
        
        for item in items {
            switch(item) {
            case .node(let loc, let name, let highlight):
                drawNode(at: loc, labelled: name, highlighted: highlight)
            case .edge(let src, let dst, let label, let highlight):
                drawEdge(from: src, to: dst, label: label, highlighted: highlight)
            }
        }
    }
    
    
    /**
     Draw a node at the given location.  The node will have
     a centered label and can be highlighted if specified.
     
     **Effects: New node appears in the current drawing context
     
     - Parameter location: Model Coordinates of the node
     - Parameter label: Name of the node.
     - Parameter highlighted: Whether to draw the node's body
     in the highlight color.
     */
    private func drawNode(at location : CGPoint,
                          labelled label: String,
                          highlighted: Bool) {
        
        // Compute path for the node
        let viewLocation = unitTransform.toView(modelPoint: location)
        let boundingBox = CGRect(x: viewLocation.x - nodeRadius,
                                 y: viewLocation.y - nodeRadius,
                                 width: nodeRadius * 2,
                                 height: nodeRadius * 2)
        let path = UIBezierPath(ovalIn:boundingBox)
        
        if highlighted {
            nodeHighlightColor.setFill()
        } else {
            nodeColor.setFill()
        }
        path.fill()
        
        outlineColor.set()
        path.stroke()
        
        drawCenteredText(at: location, text: label)
    }
    
    /**
     Draw an edge between two locations, with optional
     highlighting.
     
     **Effects**: New edge appears in the current drawing context
     
     - Parameter from: Where the edge ends, in model coordinates.
     - Parameter to: Where the edge ends, in model coordinates.
     - Parameter highlighted: Whether to draw the edge
     in the highlight color.
     */
    private func drawEdge(from srcLocation : CGPoint,
                          to dstLocation : CGPoint,
                          label : String,
                          highlighted: Bool) {
        
        let srcViewLocation = unitTransform.toView(modelPoint: srcLocation)
        let dstViewLocation = unitTransform.toView(modelPoint: dstLocation)
        
        //kaizen's additions
        let size = Int(label)! //number of blocks
        let viewDistance = CGPointDistance(from: srcViewLocation, to: dstViewLocation)
        let viewBlockSize = viewDistance/CGFloat(size) //size of blocks
        
        let  path = UIBezierPath()
        
        let  p0 = srcViewLocation
        path.move(to: p0)
        
        let  p1 = dstViewLocation
        path.addLine(to: p1)
        
        //kaizen's changes
        //dashes is an array of CGPoints where the elements alternate between size of dash and size of space in-between
        var dashes = [CGFloat]()
        //first element is dash; this offsets that property
        dashes.append(CGFloat.zero)
        //start with some spacing
        dashes.append(CGFloat(0.1*Double(viewBlockSize)))
        for _ in 0..<size {
            dashes.append(CGFloat(0.8*Double(viewBlockSize))) //add dash
            dashes.append(CGFloat(0.2*Double(viewBlockSize))) //add spacing
        }
        //update last spacing to be less because we borrowed some for the start
        dashes[dashes.count-1] = CGFloat(0.1*Double(viewBlockSize))
        path.setLineDash(dashes, count: dashes.count, phase: 0.0)
        
        path.lineWidth = lineWidth
        path.lineCapStyle = .butt
        UIColor.lightGray.set()
        path.stroke()
        
        let center = CGPoint(x: path.bounds.midX, y: path.bounds.midY)
        drawCenteredText(at: unitTransform.fromView(viewPoint: center), text: label, textColor: highlighted ? outlineHighlightColor : outlineColor, backgroundColor: UIColor.white)
        
    }
    
    /**
     Draw a text centered at the given location.
     
     **Effects    *: New text appears in the current drawing context
     
     - Parameter locations: Center of text, in model coordinates.
     - Parameter text: the text to display.
     */
    private func drawCenteredText(at location: CGPoint, text: String, textColor : UIColor? = nil, backgroundColor : UIColor? = nil) {
        
        // Compute view coordinates of center
        let viewLocation = unitTransform.toView(modelPoint: location)
        
        // Use desired color, size, and break at spaces to avoid
        // text that is overly wide.
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let text = text.replacingOccurrences(of: " ", with: "\n")
        var attrs : [NSAttributedString.Key : Any] =
            [NSAttributedString.Key.font : UIFont.systemFont(ofSize: textSize),
             NSAttributedString.Key.foregroundColor : textColor ?? self.textColor,
             NSAttributedString.Key.paragraphStyle : paragraphStyle]
        
        if let bgColor = backgroundColor {
            attrs[NSAttributedString.Key.backgroundColor] = bgColor
        }
        
        // Compute bounding box for text and then draw it in the box.
        let size = text.size(withAttributes: attrs)
        let boundingBox = CGRect(origin: CGPoint(x: viewLocation.x - size.width/2,
                                                 y: viewLocation.y - size.height / 2),
                                 size: size)
        text.draw(in: boundingBox, withAttributes: attrs)
    }
    
    // MARK: Zooming and Panning
    
    /**
     Change scale of view relative to model.
     
     **Modifies**: self
     
     **Effects**: the transform from model to view coords.
     */
    @IBAction private func pinched(_ sender: UIPinchGestureRecognizer) {
        unitTransform = unitTransform.scale(by: sender.scale)
        sender.scale = 1
    }
    
    
    /**
     Change origin of view relative to model's origin
     
     **Modifies**: self
     
     **Effects**: the transform from model to view coords.
     */
    @IBAction func panned(_ sender: UIPanGestureRecognizer) {
        if sender.state == .changed {
            let translation = sender.translation(in: sender.view)
            unitTransform = unitTransform.shift(by: translation)
            sender.setTranslation(CGPoint.zero, in: sender.view)
        }
    }
    
    /**
     Zoom in as far as possible while still showing all nodes
     and edges in items.
     
     **Modifies**: self
     
     **Effects**: the transform from model to view coords.
     */
    //  @IBAction private func doubleTapped(_ sender: UITapGestureRecognizer) {
    //    zoomToMax()
    //  }
    
    @IBAction func doubleTapped(_ sender: UITapGestureRecognizer) {
        zoomToMax()
    }
    
    
    /// - Returns : all node locatons
    private func nodePoints() -> [CGPoint]{
        var points = [CGPoint]()
        for item in items{
            switch(item) {
            case .node(let loc, _, _):
                points.append(loc)
            case .edge(_, _, _, _):
                break
            }
        }
        return points
    }
    
    /// - Returns : all node locations and edge start/end locations.
    private func points() -> [CGPoint] {
        var points = [CGPoint]()
        for item in items {
            switch(item) {
            case .node(let loc, _, _):
                points.append(loc)
            case .edge(let src, let dst, _, _):
                points.append(src)
                points.append(dst)
            }
        }
        return points
    }
    
    /**
     Adjust the zoom scale and panning to show the graph items as zoomed
     in as possible.
     
     **Modifies**: self
     
     **Effects**: changes how the model points are translated into
     view points so that the items are zoomed as much as possible while
     still sitting comfortable in the visible part of the view.
     
     */
    public func zoomToMax() {
        if (items.count > 0) {
            let points = self.points()
            
            // Compute bounding box for all points we know about.  Start with
            // an empty box at the first point, and then extend it to include
            // every other point.
            var modelBounds = CGRect(origin: points[0], size: CGSize(width: 0, height: 0))
            for p in points {
                modelBounds = modelBounds.union(CGRect(origin: p, size: CGSize.zero))
            }
            
            // Don't let the nodes be draw too close to the edge of the view...
            let insetBounds = bounds.insetBy(dx: 2 * nodeRadius, dy: 2 * nodeRadius)
            
            unitTransform = ModelToViewCoordinates(modelBounds: modelBounds,
                                                   viewBounds: insetBounds)
        }
    }
}



extension UIImage {
    
    /**
     Draw the image, scaling and positioning it according to the
     provided unit transform.  The image is assumed to
     be in the model coordinates, with its top-left corner at (0,0).
     The image is scaled/positioned in the view coordinates using the
     unitTransform.
     
     - Note: Methods that scale the entire image without considering
     the bounds of the view area it will be drawn into can be quite
     inefficient if the transformation's scale factor is very large.
     This method avoids high overheads by first cropping the image
     to only the part that will be visible in the view bounds before
     scaling it to exactly fill the provided viewBounds.
     
     - Parameter unitTransform: how to map the image's position
     and size to the view
     
     - Parameter viewBounds: the visible rectangle in view coordinates that
     we should draw into.
     
     */
    func draw(unitTransform : ModelToViewCoordinates, viewBounds: CGRect) {
        let zoomScale = unitTransform.zoomScale
        
        // compute the point in the image that will appear in top-left corner
        // of the view bounds, and also the rectangular area of the image that
        // will be scaled to cover the entire view bounds.
        let topLeftVisiblePoint = unitTransform.fromView(viewPoint: viewBounds.origin)
        let visiblePartOfImage = CGRect(origin: topLeftVisiblePoint,
                                        size: CGSize(width: viewBounds.width/zoomScale,
                                                     height: viewBounds.height/zoomScale))
        
        if let croppedImage = cgImage?.cropping(to: visiblePartOfImage) {
            // grab the part of the image we'll rescale
            let scaledImage = UIImage(cgImage: croppedImage,
                                      scale: 1/zoomScale,
                                      orientation: imageOrientation)
            
            // Since the cropping is clipped to the actual image area, we need
            // to adjust where to draw it when there will be white space to the
            // left or above.
            //
            // So, if the top-left point has, eg, a negative x position in the image
            // then we must shift where the image is drawn by that much.  Same for y.
            let x = topLeftVisiblePoint.x < 0 ? -topLeftVisiblePoint.x * zoomScale : 0
            let y = topLeftVisiblePoint.y < 0 ? -topLeftVisiblePoint.y * zoomScale : 0
            
            scaledImage.draw(at: CGPoint(x:x,y:y))
        }
    }
}
