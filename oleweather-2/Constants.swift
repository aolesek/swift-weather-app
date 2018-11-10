//
//  Constants.swift
//  oleweather-2
//
//  Created by arek on 08/11/2018.
//  Copyright © 2018 aolesek. All rights reserved.
//

import Foundation

class Constants {
    static let weatherUnitStringRepresentation = " °C"
    
    
    static var apiURL = "https://www.metaweather.com/api/location/44418/"
    
    static var todayDateFormat = "dd.MM.yyyy"
    
    static var header = "Weather in "
    
    static var detailedTempFormat = "%.1f °C"
    
    static var simpleTempFormat = "%.0f°C"
    
    static var windSpeedFormat = "%.1f kmph"
    
    static var pressureFormat = "%.1f hPa"
    
    static var humidityFormat = "%d %%"
    
    static var today = " today"
    
    static var tomorrow =  " tomorrow"
    
    static var beforeDate = " on "
    
    static var percipitationConditions = ["Snow", "Sleet", "Hail", "Heavy Rain", "Light Rain", "Showers"]
    
    static var noData = " - "
    
    static var imageURL = "https://www.metaweather.com/static/img/weather/png/"
    
    static var imageExt = ".png"
    
    static var errorNotificationTitle = "Error"
    
    static var errorNotificationMessage = "An error occured: "
    
    static var errorNotificationButton = "OK"
    
    static var conditionsLabel = "Conditions"
    
    static var tempMinLabel = "Min temperature"
    
    static var tempMaxLabel = "Max temperature"

    static var windSpeedLabel = "Wind speed"

    static var windDirectionLabel = "Wind direction"

    static var precipitationLabel = "Precipitation"

    static var airPressureLabel = "Air pressure"

    static var humidityLabel = "Humidity"
}
