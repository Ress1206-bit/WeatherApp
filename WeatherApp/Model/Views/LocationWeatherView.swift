//
//  LocationViewTesting.swift
//  WeatherApp
//
//  Created by Adam Ress on 6/2/24.
//

import SwiftUI
import CoreLocation

struct LocationWeatherView: View {
    
    @Environment(WeatherModel.self) var weatherModel
    
    @State var currentLocationData: CurrentData?
    
    
    
    
    var body: some View {
            
            if weatherModel.coordinateString != nil {
                
                ZStack{
                    Rectangle()
                        .foregroundStyle(.blue)
                        .ignoresSafeArea()
                    VStack {
                        Text(currentLocationData?.location.name ?? "- -")
                            .font(.largeTitle)
                            .fontWeight(.medium)
                            .foregroundStyle(.white)
                            .padding(.top, 50)
                        Text("\(Int(currentLocationData?.current.temp_f ?? 0))°")
                            .font(.system(size: 100))
                            .fontWeight(.thin)
                            .foregroundStyle(.white)
                            .padding(.leading, 20)
                        Text("\(currentLocationData?.current.condition?.text ?? "- -")")
                            .fontWeight(.medium)
                            .foregroundStyle(.white)
                        Text("H:\(Int(currentLocationData?.forecast.forecastday[0].day?.maxtemp_f ?? 0))° L:\(Int(currentLocationData?.forecast.forecastday[0].day?.mintemp_f ?? 0))°")
                            .fontWeight(.medium)
                            .foregroundStyle(.white)
                        ZStack{
                            Rectangle()
                                .frame(width: 350, height: 160)
                                .cornerRadius(15)
                                .foregroundStyle(.teal)
                            VStack{
                                Text("Sunny conditions will continue for the rest of the day. Wind gusts are up to 11mph.")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 14))
                                    .padding([.leading, .trailing], 10)
                                    .padding(.top, 10)
                                Divider()
                                    .overlay(.white)
                                    .padding(.leading, 15)
                                ScrollView(.horizontal, showsIndicators: false){
                                    HStack{
                                        ForEach(0..<10){ index in
                                            VStack{
                                                Text("4pm")
                                                    .font(.system(size: 13))
                                                    .padding(.top, 4)
                                                    .foregroundStyle(.white)
                                                Image(systemName: "sun.max.fill")
                                                    .foregroundStyle(.yellow)
                                                    .padding(.top, 4)
                                                    .font(.system(size: 20))
                                                Text("0°")
                                                    .padding(.top, 4)
                                                    .foregroundStyle(.white)
                                            }
                                            .padding(.trailing, 20)
                                        }
                                    }
                                    .padding([.leading, .trailing], 15)
                                }
                                Spacer()
                            }
                            .frame(width: 350, height: 160)
                            
                        }
                        .padding(.top, 55)
                        Spacer()
                        
                    }
                }
                .onAppear(){
                    Task{
                        currentLocationData = await weatherModel.apiCall(cityName: weatherModel.coordinateString!)
                    }
                }
            }
            else {
                VStack{
                    Spacer()
                    Text("My Location")
                        .font(.largeTitle)
                        .padding()
                    LoadingView()
                    Spacer()
                }
                .onAppear {
                    weatherModel.getUserLocation()
                }
            }
        

    }
}

#Preview {
    LocationWeatherView()
        .environment(WeatherModel())
}
