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
import MapKit

@objc(Location)
public class Location: NSManagedObject, MKAnnotation {
    public var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2DMake(latitude, longitude)
    }
    
    public var title: String? {
        return locationDescription.isEmpty ? "(No Description)" : locationDescription
    }
    
    public var subtitle: String? {
        return category
    }
    
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
    
    var hasPhoto: Bool {
        return photoID != nil
    }
    
    var photoURL: URL {
        assert(photoID != nil, "No photo ID is set")
        let filename = "Photo-\(photoID!.intValue).jpg"
        return applicationDocumentsDirectory.appendingPathComponent(filename)
    }
    
    var photoImage: UIImage? {
        return UIImage(contentsOfFile: photoURL.path)
    }
    
    class func nextPhotoID() -> Int {
        let userDefaults = UserDefaults.standard
        let currentID = userDefaults.integer(forKey: "PhotoID") + 1
        userDefaults.set(currentID, forKey: "PhotoID")
        userDefaults.synchronize()
        return currentID
    }
}
