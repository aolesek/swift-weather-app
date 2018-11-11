//
//  MetaWeatherApi.swift
//  oleweather-2
//
//  Created by arek on 10/11/2018.
//  Copyright © 2018 aolesek. All rights reserved.
//

import Foundation

class MetaWeatherApi {
    
    static var API_LOCATION = "https://www.metaweather.com/api"
    
    static var FORECAST_ENDPOINT = "/location/"
    
    static var SEARCH_ENDPOINT = "/location/search/?query="
    
    static var LATLON_SEARCH_ENDPOINT = "/location/search/?lattlong="
    
    func getWeather(descriptor: String, onComplete: @escaping (Forecast) -> (Void), onError: @escaping (Error) -> (Void)) {
        let url = URL(string: MetaWeatherApi.API_LOCATION + MetaWeatherApi.FORECAST_ENDPOINT + descriptor)
        let session = URLSession.shared
        
        let task = session.dataTask(with: url!) { (data, urlresponse, error) in
            do {
                let forecast = try self.deserializeWeatherData(data: data)
                onComplete(forecast)
            } catch {
                onError(error)
            }
        }
        task.resume()
    }
    
    private func deserializeWeatherData(data: Data?) throws -> Forecast  {
        if let unwrappedData = data {
            let weatherForecast = try Forecast(data: unwrappedData)
            return weatherForecast
        } else {
            throw NSError()
        }
    }
    
    func getLocations(phrase: String, onComplete: @escaping (SearchResults) -> (Void), onError: @escaping (Error) -> ()) {
        
        let simple = phrase.folding(options: [.diacriticInsensitive, .widthInsensitive, .caseInsensitive], locale: nil)
        let nonAlphaNumeric = CharacterSet.alphanumerics.inverted
        // .diacriticInsensitive does not work for Łł
        let fixedPhrase = simple.components(separatedBy: nonAlphaNumeric).joined(separator: "").replacingOccurrences(of: "ł", with: "l")
        
        let url = URL(string: MetaWeatherApi.API_LOCATION + MetaWeatherApi.SEARCH_ENDPOINT + fixedPhrase)
        let session = URLSession.shared
        
        let task = session.dataTask(with: url!) { (data, urlresponse, error) in
            do {
                let results = try self.deserializeSearchData(data: data)
                onComplete(results)
            } catch {
                onError(error)
            }
        }
        task.resume()
    }
    
    func getLocations(lat: Float, lon: Float, onComplete: @escaping (SearchResults) -> (Void), onError: @escaping (Error) -> ()) {
        let latLon = "\(lat),\(lon)"
        let url = URL(string: MetaWeatherApi.API_LOCATION + MetaWeatherApi.LATLON_SEARCH_ENDPOINT + latLon)
        let session = URLSession.shared
        print(latLon)
        
        let task = session.dataTask(with: url!) { (data, urlresponse, error) in
            do {
                let results = try self.deserializeSearchData(data: data)
                onComplete(results)
            } catch {
                onError(error)
            }
        }
        task.resume()
    }
    
    private func deserializeSearchData(data: Data?) throws -> SearchResults   {
        if let unwrappedData = data {
            let results = try SearchResults(data: unwrappedData)
            return results
        } else {
            throw NSError()
        }
    }
}
