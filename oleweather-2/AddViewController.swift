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
    
    var locationTableCell: UITableViewCell?
    
    var locationCellResult: SearchResult?
    
    var coordinates: (Float,Float)?
    
    let api = MetaWeatherApi()
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var phraseTextField: UITextField!
    
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
    
    func handleError(error: Error) {
        showErrorAlert(error: error)
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
        if locationChanged(lat: lat, lon: lon) {
            self.coordinates = (lat, lon)
            api.getLocations(lat: Float(locValue.latitude), lon:Float(locValue.longitude),
                             onComplete: { (results) -> (Void) in
                                NSLog("Nearest location for  \(locValue.latitude) \(locValue.longitude) fetched")
                                if !results.entries.isEmpty {
                                    self.locationCellResult = results.entries[0]
                                    DispatchQueue.main.async {
                                        self.locationTableCell?.textLabel?.text = Constants.currentLocation + ": " + (self.locationCellResult?.title)!
                                        self.locationTableCell?.isUserInteractionEnabled = true
                                    }
                                }
                            },
                            onError: { (error) in
                                self.handleError(error: error)
                            })
            if let cell = locationTableCell {
                cell.isUserInteractionEnabled = true
                cell.textLabel?.text = Constants.currentLocation
            }
        }
    }
    
    func locationChanged(lat: Float, lon: Float) -> Bool {
        if let coords = self.coordinates {
            return (coords.0 - lat).magnitude > Constants.locationThreshold || ((coords.1) - lon).magnitude > Constants.locationThreshold
        }
        return true
    }
    
    // TABLE VIEW
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfEntries = results?.entries.count ?? 0
        return numberOfEntries + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "foundCell") {
            let row = indexPath.row
            if row == 0 {
                cell.textLabel?.text = Constants.currentLocation
                cell.isUserInteractionEnabled = false
                self.locationTableCell = cell
                return cell
            } else {
                if let unwrappedResults = results {
                    cell.textLabel?.text = unwrappedResults.entries[row - 1].title
                    return cell
                }
            }
        }
        return UITableViewCell();
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        if row == 0 {
            if let location = locationCellResult {
                let woeid = String(location.woeid)
                delegate?.townDescriptors.append(woeid)
                DispatchQueue.main.async {
                    self.delegate?.fetchWeatherData()
                    self.dismiss(animated: true, completion: nil)
                }
            }
        } else if let unwrappedResults = results {
            let woeid = String(unwrappedResults.entries[row - 1].woeid)
            delegate?.townDescriptors.append(woeid)
            DispatchQueue.main.async {
                self.delegate?.fetchWeatherData()
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}
