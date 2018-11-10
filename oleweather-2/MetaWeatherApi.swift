//
//  MetaWeatherApi.swift
//  oleweather-2
//
//  Created by arek on 10/11/2018.
//  Copyright © 2018 aolesek. All rights reserved.
//

import Foundation

class MetaWeatherApi {
    
    static var API_LOCATION = "httpssdf://www.metaweather.com/api"
    
    static var FORECAST_ENDPOINT = "/location/"
    
    func getWeather(descriptor: String, onComplete: @escaping (Forecast) -> (Void), onError: @escaping (Error) -> ()) {
        let url = URL(string: MetaWeatherApi.API_LOCATION + MetaWeatherApi.FORECAST_ENDPOINT + descriptor)
        let session = URLSession.shared
        
        let task = session.dataTask(with: url!) { (data, urlresponse, error) in
            do {
                let forecast = try self.deserializeData(data: data)
                onComplete(forecast)
            } catch {
                onError(error)
            }
        }
        task.resume()
    }
    
    private func deserializeData(data: Data?) throws -> Forecast  {
        if let unwrappedData = data {
            let weatherForecast = try Forecast(data: unwrappedData)
            return weatherForecast
        } else {
            throw NSError()
        }
    }
}
