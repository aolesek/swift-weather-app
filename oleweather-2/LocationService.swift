//
//  LocationService.swift
//  oleweather-2
//
//  Created by arek on 11/11/2018.
//  Copyright © 2018 aolesek. All rights reserved.
//

import Foundation
import MapKit

class LocationService {
    
    static var shared = LocationService()
    
    let locationManager = CLLocationManager()
    var location: CLLocation?
    let authStatus = CLLocationManager.authorizationStatus()
    let inUse = CLAuthorizationStatus.authorizedWhenInUse
    let always = CLAuthorizationStatus.authorizedAlways
    
    func getTownAndCountry(completion: @escaping (_ location: String?, _ error: Error?) -> ()) {
        getData(geocodeCH: { placemarks, error in
            if let e = error {
                completion(nil, e)
            } else {
                let placemark = placemarks?[0]
                let location = "\(placemark?.locality ?? ""), \(placemark?.country ?? "")"
                completion(location, nil)
            }
        })
    }
    
    func getTown(completion: @escaping (_ location: String?, _ error: Error?) -> ()) {
        getData(geocodeCH: { placemarks, error in
            if let e = error {
                completion(nil, e)
            } else {
                let placemark = placemarks?[0]
                let location = "\(placemark?.locality ?? "")"
                completion(location, nil)
            }
        })
    }
    
    private func getData(geocodeCH: @escaping CLGeocodeCompletionHandler) {
        self.locationManager.requestWhenInUseAuthorization()
        if self.authStatus == inUse || self.authStatus == always {
            self.location = locationManager.location
            let geoCoder = CLGeocoder()
            if let loc = self.location {
                geoCoder.reverseGeocodeLocation(loc, completionHandler: geocodeCH)
            }
        }
    }
    
    func getCoordinates(name: String, completion: @escaping (_ location: CLPlacemark?, _ error: Error?) -> ()) {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(name) { (placemarks, error) in
            if let e = error {
                completion(nil, e)
            } else {
                let location = placemarks?[0]
                completion(location, nil)
            }
        }
    }
}
