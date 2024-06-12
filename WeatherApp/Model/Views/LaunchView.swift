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
        

        NavigationStack {
            
            ZStack(alignment: .bottom){
                
                Color.blue
                
       
                    
                TabView(selection: $selectedTab) {
                    
                    if weatherModel.coordinateString != nil {
                        LocationWeatherView()
                            .tag(0)
                        
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
                            .tag(index + 1)
                        }
                    }
                    else {
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
                
                HStack {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            HStack(spacing: 8) {
                                
                                if weatherModel.coordinateString != nil {
                                    ForEach(0..<weatherModel.cityNames.count + 1, id:\.self) { index in
                                        
                                        if index == 0 {
                                            Image(systemName: "location.fill")
                                                .frame(width: 8, height: 8)
                                                .font(.system(size: 13))
                                                .padding(.trailing, 1.5)
                                                .padding(.top, 0.5)
                                                .foregroundStyle(index == selectedTab ? Color.white : Color.black.opacity(0.75))
                                        }
                                        else {
                                            Circle()
                                                .fill(index == selectedTab ? Color.white : Color.black.opacity(0.75))
                                                .frame(width: 8, height: 8)
                                        }
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
                            .padding(.bottom, 40)
                            Spacer()
                        }
                    }
                }
                .background(.blue)
                .border(.black.opacity(0.25))
                .frame(height:40)
            }
            .edgesIgnoringSafeArea(.all)
        }
        .frame(height: UIScreen.main.bounds.size.height)
        
    }
}

#Preview {
    LaunchView()
        .environment(WeatherModel())
}
