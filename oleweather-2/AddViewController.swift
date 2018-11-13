//
//  AddViewController.swift
//  oleweather-2
//
//  Created by arek on 10/11/2018.
//  Copyright © 2018 aolesek. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class AddViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    var delegate: MasterViewController?
    
    var results: SearchResults?
    
    var locationManager: CLLocationManager?
    
    var coordinates: (Float,Float)?
    
    let api = MetaWeatherApi()
    
    @IBOutlet weak var currentLocationLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var phraseTextField: UITextField!
    
    @IBOutlet weak var nearestButton: UIButton!
    
    @IBAction func onCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onSearch(_ sender: Any) {
        phraseTextField.endEditing(true)
        if let phrase = phraseTextField?.text {
            if !phrase.isEmpty {
                api.getLocations(phrase: phrase,
                    onComplete: { (results) -> (Void) in
                        NSLog("Results for " + phrase + " fetched")
                        self.results = results
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                },
                    onError: { (error) in
                        self.handleError(error: error)
                })
            }
        }
    }
    
    @IBAction func onNearest(_ sender: Any) {
        if let coords = self.coordinates {
            api.getLocations(lat: coords.0, lon: coords.1,
                             onComplete: { (results) -> (Void) in
                                NSLog("Nearest location for  \(coords.0) \(coords.1) fetched")
                                self.results = results
                                DispatchQueue.main.async {
                                    self.tableView.reloadData()
                                }
                                self.fetchCurrentLocationIfAvailable()
            },
                             onError: { (error) in
                                self.handleError(error: error)
            })
        }
    }
    
    func fetchCurrentLocationIfAvailable(){
        guard let result = self.results else {
            return
        }
        
        guard let first = result.entries.first else {
            return
        }
        
        let locationService = LocationService.shared
        locationService.location = self.locationManager?.location!
        
        locationService.getTown(completion: {result, error in
            if let res = result {
                if res.localizedCaseInsensitiveCompare(first.title) == .orderedSame {
                    let woeid = String(first.woeid)
                    self.addWoeidAndGoBackToMaster(woeid)
                } else {
                    let alert = UIAlertController(title: nil, message: Constants.locationUnavailable, preferredStyle: .alert)
                    self.present(alert, animated: true)
                    
                    let duration: Double = 3
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration) {
                        alert.dismiss(animated: true)
                    }
                }
            }
            if let err = error {
                self.handleError(error: err)
            }
        })
    }
    
    func handleError(error: Error) {
        showErrorAlert(error: error)
        NSLog(error.localizedDescription)
    }
    
    func showErrorAlert(error: Error) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: Constants.errorNotificationTitle, message: Constants.errorNotificationMessage , preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: Constants.errorNotificationButton, style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.tableView.reloadData()
        self.initLocationManager()
        self.nearestButton?.isEnabled = false
    }
    
    func initLocationManager() {
        locationManager = CLLocationManager()
        locationManager!.delegate = self;
        locationManager!.desiredAccuracy = kCLLocationAccuracyBest
        locationManager!.requestAlwaysAuthorization()
        locationManager!.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        let lat = Float(locValue.latitude)
        let lon = Float(locValue.longitude)
        self.coordinates = (lat,lon)
        let locationService = LocationService.shared
        locationService.location = manager.location!
        locationService.getTownAndCountry{ location, error in
            if let loc = location {
                self.currentLocationLabel.text = Constants.currentLocationLabel + loc
            }
            if let err = error {
                self.handleError(error: err)
            }
        }
        
        if (self.nearestButton.isEnabled == false) {
            self.nearestButton.isEnabled = true
        }
    }
    
    // TABLE VIEW
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfEntries = results?.entries.count ?? 0
        return numberOfEntries
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "foundCell") {
            let row = indexPath.row
            if let unwrappedResults = results {
                cell.textLabel?.text = unwrappedResults.entries[row].title
                return cell
            }
        }
        return UITableViewCell();
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        if let unwrappedResults = results {
            let woeid = String(unwrappedResults.entries[row].woeid)
            addWoeidAndGoBackToMaster(woeid)
        }
    }
    
    func addWoeidAndGoBackToMaster(_ woeid: String) {
        delegate?.townDescriptors.append(woeid)
        DispatchQueue.main.async {
            self.delegate?.fetchWeatherData()
            self.dismiss(animated: true, completion: nil)
        }
    }
}
