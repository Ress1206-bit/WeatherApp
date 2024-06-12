//
//  ContentView.swift
//  WeatherApp
//
//  Created by Adam Ress on 5/30/24.
//

import SwiftUI

struct LaunchView: View {
    
    @Environment(WeatherModel.self) var weatherModel
    @State private var selectedTab = 0
    @State var weatherViews: [WeatherView] = []
    
    var body: some View {
        
        ZStack(alignment: .bottom){
            TabView(selection: $selectedTab) {
                
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
                    .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
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
            
            ZStack {
                Rectangle()
                    .background(.ultraThinMaterial)
                HStack {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            HStack(spacing: 8) {
                                
                                if weatherModel.coordinateString != nil {
                                    ForEach(0..<weatherModel.cityNames.count + 1, id:\.self) { index in
                                        Circle()
                                            .fill(index == selectedTab ? Color.white : Color.black.opacity(0.75))
                                            .frame(width: 8, height: 8)
                                    }
                                }
                                else {
                                    ForEach(0..<weatherModel.cityNames.count, id:\.self) { index in
                                        Circle()
                                            .fill(index == selectedTab ? Color.white : Color.black.opacity(0.75))
                                            .frame(width: 8, height: 8)
                                    }
                                }
                            }
                            .padding(10)
                            .cornerRadius(10)
                            .padding(.bottom, 20)
                            Spacer()
                        }
                    }
                }
            }
            .border(.black.opacity(0.25))
            .frame(height:40)
        }
        .edgesIgnoringSafeArea(.all)
        
    }
}

#Preview {
    LaunchView()
        .environment(WeatherModel())
}
