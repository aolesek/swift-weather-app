//
//  Forecast.swift
//  oleweather-2
//
//  Created by arek on 10/11/2018.
//  Copyright © 2018 aolesek. All rights reserved.
//

import Foundation

struct Forecast: Codable{
    let title: String
    let consolidatedWeather: [Weather]
    
    private enum CodingKeys: String, CodingKey {
        case title,
        consolidatedWeather = "consolidated_weather"
    }
    
    init(data: Data) throws {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .deferredToDate
        self = try decoder.decode(Forecast.self, from: data)
    }
    
    init(title: String, consolidatedWeather: [Weather]) {
        self.title = title
        self.consolidatedWeather = consolidatedWeather
    }
}
