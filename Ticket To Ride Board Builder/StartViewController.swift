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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "TTR Home"
        
    }
<<<<<<< HEAD

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
=======
    
>>>>>>> 50a92da9ea1d59b28a92d3a490876bbebfe8ab42
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? TicketToRideBuilderViewController {
            destination.model = model  // give the model to the builder.
        }
        if let destination = segue.destination as? PlayViewController {
            destination.model = model
        }
    }
}
