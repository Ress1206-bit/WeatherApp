//
//  WeatherAppApp.swift
//  WeatherApp
//
//  Created by Adam Ress on 5/30/24.
//

import SwiftUI

@main
struct WeatherApp: App {
    var body: some Scene {
        
        @State var weatherModel = WeatherModel()
        @State var cityModel = CityModel()
        
        
        WindowGroup {
            LaunchView()
                .environment(weatherModel)
                .environment(cityModel)
        }
    }
}
