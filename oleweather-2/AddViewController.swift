//
//  AddViewController.swift
//  oleweather-2
//
//  Created by arek on 10/11/2018.
//  Copyright © 2018 aolesek. All rights reserved.
//

import UIKit

class AddViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var delegate: MasterViewController?
    
    var results: SearchResults?
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var phraseTextField: UITextField!
    
    @IBAction func onCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onSearch(_ sender: Any) {
        phraseTextField.endEditing(true)
        let api = MetaWeatherApi()
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
    }
    
    // TABLE VIEW
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results?.entries.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "foundCell") {
            if let unwrappedResults = results {
                cell.textLabel?.text = unwrappedResults.entries[indexPath.row].title
                return cell
            }
        }
        return UITableViewCell();
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let unwrappedResults = results {
            let woeid = String(unwrappedResults.entries[indexPath.row].woeid)
            delegate?.townDescriptors.append(woeid)
            DispatchQueue.main.async {
                self.delegate?.fetchWeatherData()
                self.dismiss(animated: true, completion: nil)
            }
        } 
    }
}
