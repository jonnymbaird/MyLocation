//
//  FirstViewController.swift
//  MyLocation
//
//  Created by Jonathan Baird  on 10/04/2020.
//  Copyright © 2020 Jonathan Baird . All rights reserved.
//

import UIKit
import CoreLocation

class CurrentLocationViewController: UIViewController,
                                    CLLocationManagerDelegate {
    // MARK:- Outlets
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var tagButton: UIButton!
    @IBOutlet weak var getButton: UIButton!
    
    
    // MARK:- Actions
    @IBAction func getLocation() {
        let authStatus = CLLocationManager.authorizationStatus()
        if authStatus == .denied || authStatus == .restricted {
            showLocationServicesDeniedAlert()
            return
        }
        if updatingLocation {
            stopLocationManager()
        } else {
            location = nil
            lastLocationError = nil
            placemark = nil
            lastGeocodingError = nil
            startLocationManager()
        }
        updateLabels()
    }
    
    // MARK:- Properties
    let locationManager = CLLocationManager()
    var location: CLLocation?
    var updatingLocation: Bool = false
    var lastLocationError: Error?
    
    let geocoder = CLGeocoder()
    var placemark: CLPlacemark?
    var performingReverseGeoCoding = false
    var lastGeocodingError: Error?
    
    // MARK:- Override Functions
    override func viewDidLoad() {
        super.viewDidLoad()

        updateLabels()
    }
    
    // MARK:- CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("didFailWithError \(error.localizedDescription)")
        
        if (error as NSError).code == CLError.locationUnknown.rawValue {
            return
        }
        lastLocationError = error
        stopLocationManager()
        updateLabels()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.last!
        print("didUpdateLocations \(newLocation)")
        
        if newLocation.timestamp.timeIntervalSinceNow < -5 {
            return
        }
        
        if newLocation.horizontalAccuracy < 0 {
            return
        }
        
        if location == nil || location!.horizontalAccuracy > newLocation.horizontalAccuracy {
            lastLocationError = nil
            location = newLocation
            
            if newLocation.horizontalAccuracy <= locationManager.desiredAccuracy {
                print("*** We are done!")
                stopLocationManager()
            }
            updateLabels()
            
            if !performingReverseGeoCoding {
                print("*** Going to geocode")
                performingReverseGeoCoding = true
                geocoder.reverseGeocodeLocation(newLocation, completionHandler: {
                    placemarks, error in
                    self.lastGeocodingError = error
                    if error == nil, let p = placemarks, !p.isEmpty {
                        self.placemark = p.last!
                    } else {
                        self.placemark = nil
                    }
                    self.performingReverseGeoCoding = false
                    self.updateLabels()
                    
                })
            }
        }
    }
    
    func startLocationManager() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            updatingLocation = true
        }
    }
    
    func stopLocationManager() {
        if updatingLocation {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            updatingLocation = false
        }
    }

    // MARK:- Helper Methods
    func showLocationServicesDeniedAlert() {
        let alert = UIAlertController(
            title: "Location Services Disabled",
            message: "Please enable location services for this app in settings.",
            preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: "OK",
            style: .default,
            handler: nil)
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func updateLabels() {
        if let location = location {
            latitudeLabel.text = String(format: "%.8f", location.coordinate.latitude)
            longitudeLabel.text = String(format: "%.8f", location.coordinate.longitude)
            tagButton.isHidden = false
            messageLabel.text = ""
            
            if let placemark = placemark {
                addressLabel.text = string(from: placemark)
            } else if performingReverseGeoCoding {
                addressLabel.text = "Searching for Address..."
            } else if lastGeocodingError != nil {
                addressLabel.text = "Error Finding Address"
            } else {
                addressLabel.text = "No Address Found"
            }
        } else {
            latitudeLabel.text = ""
            longitudeLabel.text = ""
            addressLabel.text = ""
            tagButton.isHidden = true
            
            let statusMessage: String
            if let error = lastLocationError as NSError? {
                if error.domain == kCLErrorDomain &&
                    error.code == CLError.denied.rawValue {
                    statusMessage = "Location Services Disabled"
                } else {
                    statusMessage = "Error Getting Location"
                }
            } else if !CLLocationManager.locationServicesEnabled() {
                statusMessage = "Location Services Disabled"
            } else if updatingLocation {
                statusMessage = "Searching..."
            } else {
                statusMessage = "Tap 'Get My Location' to Start"
            }
            messageLabel.text = statusMessage
        }
        configureGetButton()
    }
    
    func configureGetButton() {
        if updatingLocation {
            getButton.setTitle("Stop", for: .normal)
        } else {
            getButton.setTitle("Get My Location", for: .normal)
        }
    }
    
    func string(from placemark: CLPlacemark) -> String {
        var line1 = ""
        if let s = placemark.name {
            line1 += s + ", "
        }
        if let s = placemark.subThoroughfare {
            line1 += s + " "
        }
        if let s = placemark.thoroughfare {
            line1 += s
        }
        
        var line2 = ""
        if let s = placemark.locality {
            line2 += s + ", "
        }
        if let s = placemark.administrativeArea {
            line2 += s + ", "
        }
        if let s = placemark.postalCode {
            line2 += s
        }
        if let s = placemark.country {
            line2 += s
        }
        
        return line1 + "\n" + line2
    }
}

