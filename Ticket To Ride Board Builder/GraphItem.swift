//
//  GraphItem.swift
//  ConnectTheDots
//
//  Created by freund on 9/6/18.
//  Copyright © 2018 Stephen Freund. All rights reserved.
//

import Foundation
import CoreGraphics

/**
 
 Items that can be displayed by a GraphView.  These describe
 nodes and edges, but the locations do not correspond to points
 in the view --- they are in their own coordinate system so that
 the view can zoom and scroll over them.
 
 */
public enum GraphItem {
  
  /// A node at the given location and labelled with name.
  /// The highlighted flag indicates whether this is drawn specially or not.
  case node(loc: CGPoint, name: String, highlighted: Bool)
  
  /// An edge from one locatin to another.
  /// The highlighted flag indicates whether this is drawn specially or not.
  case edge(src: CGPoint, dst: CGPoint, label: String, highlighted: Bool)
}

