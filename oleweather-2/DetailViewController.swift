//
//  DetailViewController.swift
//  oleweather-2
//
//  Created by arek on 07/11/2018.
//  Copyright © 2018 aolesek. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!

    @IBOutlet weak var townLabel: UILabel!
    @IBOutlet weak var tempLabel: NSLayoutConstraint!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    var day: Int = 0;
    
    var tableData = ["jeden", "dwa"]
    
    func configureView() {
        // Update the user interface for the detail item.
        updateWeatherView(weatherForecast: weatherForecast)      
    }
    
    func updateWeatherView(weatherForecast: Forecast?) {
        if let forecast = weatherForecast {
            let dayForecast = forecast.consolidatedWeather[self.day];
            
            if let town = townLabel { town.text = forecast.title }
            if let temp = temperatureLabel { temp.text = String(format: Constants.simpleTempFormat, dayForecast.theTemp) }
            if let sweetImage = image {
                sweetImage.image = ConditionsTypeImageProvider.getImage(abbr: dayForecast.conditionsAbbr)
            }
            
            if let table = tableView {
                table.beginUpdates()
                tableData.append("dupa")
                table.insertRows(at: [IndexPath.init(row: self.tableData.count-1, section: 0)], with: .automatic)
                table.endUpdates()

                
               
            }
//            self.townLabel =
//
//            let todayDate = Date()
//            let formatter = DateFormatter()
//            formatter.dateFormat = Constants.todayDateFormat
//            self.today.text = formatter.string(from: todayDate)
//
//            self.header.text = Constants.header  + unwrappedForecast.title + determineWeatherDay(selectedDayForecast: selectedDayForecast)
//            self.conditionsType.text = selectedDayForecast.conditionsType;
//            self.minTemp.text = String(format: Constants.detailedTempFormat, selectedDayForecast.minTemp)
//            self.theTemp.text = String(format: Constants.simpleTempFormat, selectedDayForecast.theTemp)
//            self.maxTemp.text = String(format: Constants.detailedTempFormat, selectedDayForecast.maxTemp)
//            self.windSpeed.text = String(format: Constants.windSpeedFormat, selectedDayForecast.windSpeed)
//            self.windDirection.text = selectedDayForecast.windDirection;
//            self.precipitation.text = self.determinePrecipitation(conditions: selectedDayForecast.conditionsType)
//            self.airPressure.text = String(format: Constants.pressureFormat, selectedDayForecast.airPressure)
//            self.humidity.text = String(format: Constants.humidityFormat, selectedDayForecast.humidity)
//            self.setConditionsImage(conditionsAbbreviation: selectedDayForecast.conditionsAbbr)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
        configureView()
    }

    var weatherForecast: Forecast? {
        didSet {
            // Update the view.
            configureView()
        }
    }
}

