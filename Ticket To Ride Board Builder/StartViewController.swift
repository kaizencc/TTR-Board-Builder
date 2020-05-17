//
//  StartViewController.swift
//  Ticket To Ride Board Builder
//
//  Created by Dominic Chui on 5/15/20.
//  Copyright © 2020 CS326. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {
    
    private let model = TTRBModel()  // model shared by all controllers
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? TicketToRideBuilderViewController {
            destination.model = model  // give the model to the builder.
        }
        if let destination = segue.destination as? PlayViewController {
            destination.model = model
        }
    }
}
