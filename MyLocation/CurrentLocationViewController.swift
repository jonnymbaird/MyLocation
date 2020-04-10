//
//  FirstViewController.swift
//  MyLocation
//
//  Created by Jonathan Baird  on 10/04/2020.
//  Copyright © 2020 Jonathan Baird . All rights reserved.
//

import UIKit

class CurrentLocationViewController: UIViewController {
    // MARK:- Outlets
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var tagButton: UIButton!
    @IBOutlet weak var getButton: UIButton!
    
    // MARK:- Actions
    @IBAction func getLocation() {
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

