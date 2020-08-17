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
            text.add(text: placemark.subThoroughfare, separatedBy: "")
            text.add(text: placemark.thoroughfare, separatedBy: ", ")
            text.add(text: placemark.locality, separatedBy: ", ")
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
    
    func removePhotoFile() {
        if hasPhoto {
            do {
                try FileManager.default.removeItem(at: photoURL)
            } catch {
                print("Error removing file: \(error)")
            }
        }
    }
    
    class func nextPhotoID() -> Int {
        let userDefaults = UserDefaults.standard
        let currentID = userDefaults.integer(forKey: "PhotoID") + 1
        userDefaults.set(currentID, forKey: "PhotoID")
        userDefaults.synchronize()
        return currentID
    }
}
