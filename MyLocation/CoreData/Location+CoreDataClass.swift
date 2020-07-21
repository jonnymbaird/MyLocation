//
//  Location+CoreDataClass.swift
//  MyLocation
//
//  Created by Jonathan Baird  on 28/06/2020.
//  Copyright © 2020 Jonathan Baird . All rights reserved.
//
//

import Foundation
import CoreData

@objc(Location)
public class Location: NSManagedObject {
    func returnAddress() -> String {
        var text = ""
        if let placemark = self.placemark {
          if let s = placemark.subThoroughfare {
            text += s + " "
          }
          if let s = placemark.thoroughfare {
            text += s + ", "
          }
          if let s = placemark.locality {
            text += s
          }
        } else {
            text = String(format: "Lat: %.8f, Long: %.8f",
                          self.latitude,
                          self.longitude)
        }
        return text
    }
}
