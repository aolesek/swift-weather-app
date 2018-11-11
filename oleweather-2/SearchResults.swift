//
//  SearchResults.swift
//  oleweather-2
//
//  Created by arek on 11/11/2018.
//  Copyright © 2018 aolesek. All rights reserved.
//

import Foundation

struct SearchResults {

    let entries: [SearchResult]

    init(data: Data)  throws {
        let decoder = JSONDecoder()
        self.entries = try decoder.decode([SearchResult].self, from: data)
    }
}
