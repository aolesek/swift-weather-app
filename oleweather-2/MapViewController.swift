//
//  MapViewController.swift
//  oleweather-2
//
//  Created by arek on 12/11/2018.
//  Copyright © 2018 aolesek. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    
    var townName: String?
    
    @IBAction func onBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let town = townName {
            showTown(town)
        }
    }
    
    func showTown(_ town: String) {
        let locationService = LocationService.shared
        locationService.getCoordinates(name: town, completion: { location, error in
            if let loc = location {
                if let coords = loc.location?.coordinate {
                    self.mapView.setCenter(coords, animated: true)
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coords
                    annotation.title = town
                    self.mapView.addAnnotation(annotation)

                }
            }
            if let err = error {
                print(err.localizedDescription)
            }
        })
    }
}
