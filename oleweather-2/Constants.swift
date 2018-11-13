//
//  Constants.swift
//  oleweather-2
//
//  Created by arek on 08/11/2018.
//  Copyright © 2018 aolesek. All rights reserved.
//

import Foundation

class Constants {
    
    static var initialTownDescriptors = ["1047372", "28743736", "455825"]
    
    static var detailedTempFormat = "%.1f °C"
    
    static var simpleTempFormat = "%.0f°C"
    
    static var windSpeedFormat = "%.1f kmph"
    
    static var pressureFormat = "%.1f hPa"
    
    static var humidityFormat = "%d %%"
    
    static var percipitationConditions = ["Snow", "Sleet", "Hail", "Heavy Rain", "Light Rain", "Showers"]
    
    static var noData = " - "
    
    static var errorNotificationTitle = "Error"
    
    static var errorNotificationMessage = "An error occured"
    
    static var errorNotificationButton = "OK"
    
    static var conditionsLabel = "Conditions"
    
    static var tempMinLabel = "Min temperature"
    
    static var tempMaxLabel = "Max temperature"

    static var windSpeedLabel = "Wind speed"

    static var windDirectionLabel = "Wind direction"

    static var precipitationLabel = "Precipitation"

    static var airPressureLabel = "Air pressure"

    static var humidityLabel = "Humidity"
    
    static var currentLocation = "Nearest available location"
    
    static var locationThreshold: Float = 0.005
    
    static var currentLocationLabel = "Your current location is "
    
    static var dataNotFetchedYet = "Data is not available yet"
    
    static var locationUnavailable = "Current location is unavailable, select one of nearest locations"
}
