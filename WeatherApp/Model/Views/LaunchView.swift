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
    
    var cityNames = ["Atlanta", "London", "Cape Town", "Madrid", "Sydney", "Los Angeles"]
    @State var weatherViews: [WeatherView] = []

    var body: some View {
        
        ZStack(alignment: .bottom){
            TabView(selection: $selectedTab) {
                
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
                    .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
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
            
            HStack {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        HStack(spacing: 8) {
                            ForEach(0..<cityNames.count, id:\.self) { index in
                                Circle()
                                    .fill(index == selectedTab ? Color.white : Color.black.opacity(0.75))
                                    .frame(width: 8, height: 8)
                            }
                        }
                        .padding(10)
//                        .background(Color.black.opacity(0.50))
                        .cornerRadius(10)
                        .padding(.bottom, 20)
                        Spacer()
                    }
                }
            }
//            .background(.black.opacity(0.25))
            .background(.blue)
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
