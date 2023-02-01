//
//  Videos.swift
//  Movie App UIKit Programmatically
//
//  Created by Jonathan Ricky Sandjaja on 01/02/23.
//

import Foundation

struct VideoResponse: Codable {
    var results: [Videos]
}

struct Videos: Codable {
    let id: String
    let name: String
    let key: String
}
