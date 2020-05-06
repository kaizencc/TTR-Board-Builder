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

class TicketToRideBuilderViewController: UIViewController {
    
    //Model
    
    private let model = TTRBModel()
    
    //View
        
    @IBOutlet weak var ttrbview: TTRBView!
    private var mode = Mode.addNode
    
    private var counter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
    }
    
}

