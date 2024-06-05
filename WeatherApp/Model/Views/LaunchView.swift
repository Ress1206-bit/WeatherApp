//
//  ContentView.swift
//  WeatherApp
//
//  Created by Adam Ress on 5/30/24.
//

import SwiftUI

struct LaunchView: View {
    
    @Environment(WeatherModel.self) var weatherModel

    @State var weatherViews: [WeatherView] = []

    var body: some View {
        
        TabView {
            
            if weatherModel.coordinateString != nil {
                LocationWeatherView()
            }

            ForEach(Array(weatherModel.cityNames.enumerated()), id: \.1) { index, name in
                VStack {
                    if weatherViews.count == weatherModel.cityNames.count {
                        weatherViews[index]
                    }
                    else {
                        VStack{
                            Spacer()
                            Text(name)
                                .font(.largeTitle)
                                .padding()
                            LoadingView()
                                .padding()
                            Spacer()
                        }
                    }
                }
            }
        }
        .tabViewStyle(.page)
        .onAppear() {
            Task {
                var tempWeatherViews: [Int: WeatherView] = [:] // Temporary dictionary
                
                for (index, name) in weatherModel.cityNames.enumerated() {
                    if let model = await weatherModel.apiCall(cityName: name) {
                        let weatherView = weatherModel.getWeatherView(currentData: model)
                        tempWeatherViews[index] = weatherView
                    }
                }
                weatherViews = weatherModel.cityNames.indices.map { tempWeatherViews[$0]! }
            }
            
            weatherModel.getUserLocation()
        }
        .ignoresSafeArea()
        
    }
}

#Preview {
    LaunchView()
        .environment(WeatherModel())
}
