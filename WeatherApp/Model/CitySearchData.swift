//
//  CitySearchData.swift
//  WeatherApp
//
//  Created by Avi Nebel on 6/11/24.
//

import Foundation

//struct CityResults: Decodable {
//    var cities: [Cities]?
//}

struct Cities: Decodable {
    var id: Int?
    var name: String?
    var region: String?
    var country: String?
    var lat: Double?
    var lon: Double?
    var url: String?
}
