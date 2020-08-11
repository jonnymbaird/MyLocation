//
//  LocationCell.swift
//  MyLocation
//
//  Created by Jonathan Baird  on 21/07/2020.
//  Copyright © 2020 Jonathan Baird . All rights reserved.
//

import UIKit

class LocationCell: UITableViewCell {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(for location: Location) {
        let hasDescription = !location.locationDescription.isEmpty
        descriptionLabel.text = hasDescription ? location.locationDescription : "(No Description)"
        
        addressLabel.text = location.returnAddress()
        
        
    }

}
