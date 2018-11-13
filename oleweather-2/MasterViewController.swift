//
//  MasterViewController.swift
//  oleweather-2
//
//  Created by arek on 07/11/2018.
//  Copyright © 2018 aolesek. All rights reserved.
//

import UIKit

extension Collection where Indices.Iterator.Element == Index {
    subscript (safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    
    var townDescriptors = Constants.initialTownDescriptors
    
    var forecasts: [(Forecast, String)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = editButtonItem
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        navigationItem.rightBarButtonItem = addButton
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        fetchWeatherData()
    }
    
    func fetchWeatherData() {
        self.forecasts.removeAll()
        let api = MetaWeatherApi()
        townDescriptors.forEach { descriptor in
            api.getWeather(descriptor: descriptor,
                           onComplete: { (forecast) -> (Void) in
                            NSLog("Forecast for " + descriptor + " fetched")
                            self.forecasts.append((forecast, descriptor))
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
            },
                           onError: { (error) in
                            self.handleError(error: error)
            })
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
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

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }
    
    @objc
    func insertNewObject(_ sender: Any) {
        performSegue(withIdentifier: "addTownSegue", sender: self)
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let weatherForecast = forecasts[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.weatherForecast = weatherForecast.0
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        } else if segue.identifier == "addTownSegue" {
            let controller : AddViewController = segue.destination as! AddViewController
            controller.delegate = self
            
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecasts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell") as! TownTableCellTableViewCell
        guard let forecast = forecasts[safe: indexPath.row] else {
            cell.towne.text = Constants.dataNotFetchedYet
            return cell
        }
        let todaysForecast = forecast.0.consolidatedWeather[0]
        let todaysTemp = todaysForecast.theTemp
        let conditionsType = ConditionsType.init(rawValue: todaysForecast.conditionsAbbr)

        if let type = conditionsType {
            let imageProvider = ConditionsTypeImageProvider(typeEnum: type)
            cell.imagee?.image = imageProvider.weatherImage
        }
        cell.towne.text = forecast.0.title
        cell.temperaturee.text = String(format: Constants.simpleTempFormat, todaysTemp)
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            townDescriptors.removeAll(where: { (desc) in desc == forecasts[indexPath.row].1})
            forecasts.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
}

