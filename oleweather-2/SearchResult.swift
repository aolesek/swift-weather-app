//
//  SearchResult.swift
//  oleweather-2
//
//  Created by arek on 11/11/2018.
//  Copyright © 2018 aolesek. All rights reserved.
//

import Foundation

struct SearchResult: Codable {
    let title: String
    let locationType: String;
    let woeid: Int32
    let lattLong: String
    
    private enum CodingKeys: String, CodingKey {
        case title,
        locationType = "location_type",
        woeid,
        lattLong = "latt_long"
    }
    
    init(data: Data)  throws {
        let decoder = JSONDecoder()
        self = try decoder.decode(SearchResult.self, from: data)
    }
}
