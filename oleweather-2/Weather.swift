//
//  Weather.swift
//  oleweather-2
//
//  Created by arek on 10/11/2018.
//  Copyright © 2018 aolesek. All rights reserved.
//

import Foundation

struct Weather: Codable {
    let conditionsType: String
    let conditionsAbbr: String;
    let minTemp: Float
    let theTemp: Float
    let maxTemp: Float
    let windSpeed: Float
    let windDirection: String
    let airPressure: Float
    let humidity: Int
    let date: String
    
    private enum CodingKeys: String, CodingKey {
        case conditionsType = "weather_state_name",
        conditionsAbbr = "weather_state_abbr",
        minTemp = "min_temp",
        theTemp = "the_temp",
        maxTemp = "max_temp",
        windSpeed = "wind_speed",
        windDirection = "wind_direction_compass",
        airPressure = "air_pressure",
        humidity,
        date = "applicable_date"
    }
    
    init(data: Data) throws {
        let decoder = JSONDecoder()
        self = try decoder.decode(Weather.self, from: data)
    }
    
    init (conditionsType: String, conditionsAbbr: String, minTemp: Float, theTemp: Float, maxTemp: Float, windSpeed: Float, windDirection: String, airPressure: Float, humidity: Int, date: String) {
        self.conditionsType = conditionsType
        self.conditionsAbbr = conditionsAbbr
        self.minTemp = minTemp
        self.theTemp = theTemp
        self.maxTemp = maxTemp
        self.windSpeed = windSpeed
        self.windDirection = windDirection
        self.airPressure = airPressure
        self.humidity = humidity
        self.date = date
    }
}
