//
//  MasterViewController.swift
//  oleweather-2
//
//  Created by arek on 07/11/2018.
//  Copyright © 2018 aolesek. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    
    var townDescriptors = [1047372, 28743736, 2471217, 523920, 44418, 638242]
    
    var forecasts = [
        Forecast(title: "Denpasar", consolidatedWeather:
            [
                Weather(conditionsType: "Snow", conditionsAbbr: "h", minTemp: 10.10, theTemp: 10, maxTemp: 10.1010, windSpeed: 10, windDirection: "NNE", airPressure: 1010.10, humidity: 10, date: "10-12-2018"),
                Weather(conditionsType: "Snow", conditionsAbbr: "h", minTemp: 10.10, theTemp: 10, maxTemp: 10.1010, windSpeed: 10, windDirection: "NNE", airPressure: 1010.10, humidity: 10, date: "11-12-2018"),
                Weather(conditionsType: "Snow", conditionsAbbr: "h", minTemp: 10.10, theTemp: 10, maxTemp: 10.1010, windSpeed: 10, windDirection: "NNE", airPressure: 1010.10, humidity: 10, date: "12-12-2018"),
                Weather(conditionsType: "Snow", conditionsAbbr: "h", minTemp: 10.10, theTemp: 10, maxTemp: 10.1010, windSpeed: 10, windDirection: "NNE", airPressure: 1010.10, humidity: 10, date: "13-12-2018"),
                Weather(conditionsType: "Snow", conditionsAbbr: "h", minTemp: 10.10, theTemp: 10, maxTemp: 10.1010, windSpeed: 10, windDirection: "NNE", airPressure: 1010.10, humidity: 10, date: "14-12-2018")
            ]),
        Forecast(title: "London", consolidatedWeather: [Weather(conditionsType: "Rain", conditionsAbbr: "sn", minTemp: 20.3, theTemp: 20, maxTemp: 20.3, windSpeed: 20.2, windDirection: "NNE", airPressure: 2020.7, humidity: 20, date: "11-12-2018")]),
        Forecast(title: "Los Angeles", consolidatedWeather: [Weather(conditionsType: "Sleet", conditionsAbbr: "c", minTemp: 35.3, theTemp: 35, maxTemp: 35.3, windSpeed: 35.2, windDirection: "NNE", airPressure: 3535.7, humidity: 35, date: "11-12-2018")])
    ]


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.leftBarButtonItem = editButtonItem

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        navigationItem.rightBarButtonItem = addButton
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    @objc
    func insertNewObject(_ sender: Any) {
//        objects.insert(NSDate(), at: 0)
//        let indexPath = IndexPath(row: 0, section: 0)
//        tableView.insertRows(at: [indexPath], with: .automatic)
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let weatherForecast = forecasts[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.weatherForecast = weatherForecast
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
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
        let forecast = forecasts[indexPath.row]
        let todaysForecast = forecast.consolidatedWeather[0]
        let todaysTemp = todaysForecast.theTemp
        let conditionsType = ConditionsType.init(rawValue: todaysForecast.conditionsAbbr)
        let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell") as! TownTableCellTableViewCell

        if let type = conditionsType {
            let imageProvider = ConditionsTypeImageProvider(typeEnum: type)
            cell.imagee?.image = imageProvider.weatherImage
        }
        cell.towne.text = forecast.title
        cell.temperaturee.text = String(format: Constants.simpleTempFormat, todaysTemp)
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
//            objects.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }


}

