//
//  DetailViewController.swift
//  oleweather-2
//
//  Created by arek on 07/11/2018.
//  Copyright © 2018 aolesek. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var day: Int = 0;

    @IBOutlet weak var detailDescriptionLabel: UILabel!

    @IBOutlet weak var townLabel: UILabel!
    @IBOutlet weak var tempLabel: NSLayoutConstraint!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var prevButton: UIButton!
    
    //MARK: Actions
    @IBAction func onPrevious(_ sender: Any) {
        if self.day > 0 {
            self.day -= 1
            self.nextButton.isEnabled = true;
        }
        if self.day <= 0 {
            self.day = 0;
            self.prevButton.isEnabled = false;
        }
        updateWeatherView()
    }
    
    @IBAction func onNext(_ sender: Any) {
        let daysNumber = self.weatherForecast!.consolidatedWeather.count - 1;
        if self.day < daysNumber  {
            self.day += 1
            self.prevButton.isEnabled = true;
        }
        if self.day >= daysNumber {
            self.day = daysNumber;
            self.nextButton.isEnabled = false;
        }
        updateWeatherView()
    }
    

    
    func configureView() {
        // Update the user interface for the detail item.
        updateWeatherView()
        
        if self.weatherForecast?.consolidatedWeather.count ?? 0 > 1 {
            DispatchQueue.main.async {
                self.nextButton.isEnabled = true;
            }
        }
    }
    
    func updateWeatherView() {
        if let forecast = weatherForecast {
            let dayForecast = forecast.consolidatedWeather[self.day];
            
            if let town = townLabel { town.text = forecast.title }
            if let temp = temperatureLabel { temp.text = String(format: Constants.simpleTempFormat, dayForecast.theTemp) }
            if let sweetImage = image {
                sweetImage.image = ConditionsTypeImageProvider.getImage(abbr: dayForecast.conditionsAbbr)
            }
            if let date = dayLabel { date.text = dayForecast.date }
            
            //refresh table view?
            DispatchQueue.main.async { self.tableView.reloadData() }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
        configureView()
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
    }

    var weatherForecast: Forecast? {
        didSet {
            // Update the view.
            configureView()
        }
    }
    
    // TABLE VIEW
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8 // your number of cell here
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "infoCell") {
            if let selectedDayForecast = weatherForecast?.consolidatedWeather[day] {
                createCellContents(cell: cell, row: indexPath.row, selectedDayForecast: selectedDayForecast)
                return cell
            }
        }
        return UITableViewCell();
    }
    
    private func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        // do nothing
    }
    
    func createCellContents(cell: UITableViewCell, row: Int, selectedDayForecast: Weather) {
        switch row {
        case 0:
            cell.textLabel?.text = Constants.conditionsLabel
            cell.detailTextLabel?.text = selectedDayForecast.conditionsType
        case 1:
            cell.textLabel?.text = Constants.tempMinLabel
            cell.detailTextLabel?.text = String(format: Constants.detailedTempFormat, selectedDayForecast.minTemp)
        case 2:
            cell.textLabel?.text = Constants.tempMaxLabel
            cell.detailTextLabel?.text = String(format: Constants.detailedTempFormat, selectedDayForecast.maxTemp)
        case 3:
            cell.textLabel?.text = Constants.windSpeedLabel
            cell.detailTextLabel?.text = String(format: Constants.windSpeedFormat, selectedDayForecast.windSpeed)
        case 4:
            cell.textLabel?.text = Constants.windDirectionLabel
            cell.detailTextLabel?.text = selectedDayForecast.windDirection
        case 5:
            cell.textLabel?.text = Constants.precipitationLabel
            cell.detailTextLabel?.text = self.determinePrecipitation(conditions: selectedDayForecast.conditionsType)
        case 6:
            cell.textLabel?.text = Constants.airPressureLabel
            cell.detailTextLabel?.text = String(format: Constants.pressureFormat, selectedDayForecast.airPressure)
        case 7:
            cell.textLabel?.text = Constants.humidityLabel
            cell.detailTextLabel?.text = String(format: Constants.humidityFormat, selectedDayForecast.humidity)
        default:
            ()
        }
    }
    
    func determinePrecipitation(conditions: String) -> String {
        return Constants.percipitationConditions.contains(conditions) ? conditions : Constants.noData
    }
}

