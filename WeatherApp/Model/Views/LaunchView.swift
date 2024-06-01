//
//  ContentView.swift
//  WeatherApp
//
//  Created by Adam Ress on 5/30/24.
//

import SwiftUI

struct LaunchView: View {
    
    @Environment(WeatherModel.self) var weatherModel

    var body: some View {
        
        TabView {
            
            
            let allData: [CurrentData] = []
            
            ForEach(allData) { _ in
                VStack {
                    Text("hello")
                }
            }
        }
        .tabViewStyle(.page)
        .onAppear() {
                weatherModel.loadWeatherData()
        }
        
    }
}

#Preview {
    LaunchView()
        .environment(WeatherModel())
}
