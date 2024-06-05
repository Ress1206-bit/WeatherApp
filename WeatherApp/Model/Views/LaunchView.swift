//
//  ContentView.swift
//  WeatherApp
//
//  Created by Adam Ress on 5/30/24.
//

import SwiftUI

struct LaunchView: View {
    
    @Environment(WeatherModel.self) var weatherModel
    
    var cityNames = ["Atlanta", "London", "Cape Town", "Madrid"]
    @State var weatherViews: [WeatherView] = []

    var body: some View {
        
        TabView {

            ForEach(Array(cityNames.enumerated()), id: \.1) { index, name in
                VStack {
                    if weatherViews.count == cityNames.count {
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
            for name in cityNames {
                Task {
                    if let model = await weatherModel.apiCall(cityName: name) {
                        weatherViews.append(weatherModel.getWeatherView(currentData: model))
                    }
                }
            }
        }
        .ignoresSafeArea()
        
    }
}

#Preview {
    LaunchView()
        .environment(WeatherModel())
}
