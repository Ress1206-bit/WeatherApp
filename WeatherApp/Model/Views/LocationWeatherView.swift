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
    
    @State var weatherData: CurrentData?
    @State private var selectedTab = 0
    
    
    
    
    var body: some View {
            
            if weatherModel.coordinateString != nil {
                
                ZStack{
                    Rectangle()
                        .foregroundStyle(.blue)
                        .ignoresSafeArea()
                    VStack {
                        Text("My Location")
                            .font(.largeTitle)
                            .fontWeight(.medium)
                            .foregroundStyle(.white)
                            .padding(.top, 35)
                        Text("\(weatherData?.location.name ?? "- -")")
                            .font(.headline)
                            .fontWeight(.medium)
                            .foregroundStyle(.white)
                        ScrollView {
                            Text("\(Int(weatherData?.current.temp_f ?? 999))°")
                                .font(.system(size: 100))
                                .fontWeight(.thin)
                                .foregroundStyle(.white)
                                .padding(.leading, 20)
                            Text("Feels Like: \(String(Int(weatherData?.current.feelslike_f ?? 999)))º")
                                .foregroundStyle(.white)
                                .fontWeight(.medium)
                            Text("\(weatherData?.current.condition?.text ?? "- -")")
                                .fontWeight(.medium)
                                .foregroundStyle(.white)
                            Text("H:\(Int(weatherData?.forecast.forecastday[0].day?.maxtemp_f ?? 999))° L:\(Int(weatherData?.forecast.forecastday[0].day?.mintemp_f ?? -999))°")
                                .fontWeight(.medium)
                                .foregroundStyle(.white)
                                .padding(.bottom, 50)
                            ForecastView(weatherData: weatherData)
                            ZStack {
                                RoundedRectangle(cornerRadius: 15)
                                    .frame(width: 350, height: 160)
                                    .foregroundStyle(.black.opacity(0.25))
                                    .shadow(color: .white, radius: 50)
                                TabView {
                                    HStack {
                                        Spacer()
                                        HStack {
                                            Image(systemName: "sunrise.fill")
                                                .scaleEffect(1.5)
                                                .symbolRenderingMode(.multicolor)
                                                .padding(.trailing,10)
                                            VStack {
                                                Text("Sunrise")
                                                    .font(.system(size: 20))
                                                Text(String(weatherData?.forecast.forecastday[0].astro?.sunrise ?? "- -"))
                                            }
                                        }
                                        .padding(2.5)
                                        Spacer()
                                        HStack {
                                            Image(systemName: "sunset.fill")
                                                .scaleEffect(1.5)
                                                .symbolRenderingMode(.multicolor)
                                                .padding(.trailing,10)
                                            VStack {
                                                Text("Sunset")
                                                    .font(.system(size: 20))
                                                Text(String(weatherData?.forecast.forecastday[0].astro?.sunset ?? "- -"))
                                            }
                                        }
                                        .padding(2.5)
                                        Spacer()
                                    }
                                    HStack {
                                        VStack {
                                            HStack {
                                                Image(systemName: "moonrise")
                                                    .scaleEffect(1.25)
                                                VStack {
                                                    Text("Moonrise")
                                                        .font(.system(size: 20))
                                                    Text(String(weatherData?.forecast.forecastday[0].astro?.moonrise ?? "- -"))
                                                }
                                            }
                                            .padding(2.5)
                                            HStack {
                                                Image(systemName: "moonset")
                                                    .scaleEffect(1.25)
                                                VStack {
                                                    Text("Moonset")
                                                        .font(.system(size: 20))
                                                    Text(String(weatherData?.forecast.forecastday[0].astro?.moonset ?? "- -"))
                                                }
                                            }
                                        }
                                        .padding(2.5)
                                        Spacer()
                                        Spacer()
                                        VStack {
                                            Text("Moon Phase: ")
                                                .font(.system(size: 20))
                                            Image(systemName: "moonphase.\(weatherData?.forecast.forecastday[0].astro?.moon_phase?.lowercased().replacingOccurrences(of: " ", with: ".") ?? "new.moon")")
                                                .font(.system(size: 35))
                                                .padding([.top,.bottom], 2.5)
                                            Text(String(weatherData?.forecast.forecastday[0].astro?.moon_phase ?? "- -"))
                                                .font(.system(size: 20))
                                        }
                                        Spacer()
                                    }
                                    .padding([.bottom, .leading, .trailing], 15)
                                }
                                .tabViewStyle(.page)
                                .indexViewStyle(.page(backgroundDisplayMode: .never))
                                .frame(width: 350, height: 160)
                                .foregroundStyle(Color.white)
                            }
                            ZStack {
                                RoundedRectangle(cornerRadius: 15)
                                    .frame(width: 350, height: 160)
                                    .foregroundStyle(.black.opacity(0.25))
                                    .shadow(color: .white, radius: 50)
                                HStack {
                                    Spacer()
                                    Spacer()
                                    VStack {
                                        Text("UV Index:")
                                            .font(.system(size: 20))
                                        Text(String(Int(weatherData?.current.uv ?? 999)))
                                            .font(.system(size: 20))
                                            .padding(.bottom, 5)
                                        Image(systemName: "sun.max")
                                            .font(.system(size: 30))
                                    }
                                    Spacer()
                                    VStack {
                                        Text("Humidity:")
                                            .font(.system(size: 20))
                                        Text(String(weatherData?.current.humidity ?? 999))
                                            .font(.system(size: 20))
                                            .padding(.bottom, 5)
                                        Image(systemName: "humidity")
                                            .font(.system(size: 30))
                                    }
                                    Spacer()
                                    Spacer()
                                }
                                .foregroundColor(.white)
                            }
                            ZStack {
                                RoundedRectangle(cornerRadius: 15)
                                    .frame(width: 350, height: 160)
                                    .foregroundStyle(.black.opacity(0.25))
                                    .shadow(color: .white, radius: 50)
                                VStack {
                                    Spacer()
                                    HStack {
                                        Text("Wind Info:")
                                            .padding(.top, 30)
                                            .fontWeight(.medium)
                                        Image(systemName: "wind")
                                            .padding(.top, 25)
                                            .scaleEffect(1.25)
                                    }
                                    Divider()
                                        .overlay(.white)
                                        .padding([.leading,.trailing], 15)
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack {
                                            VStack {
                                                Text("Direction:")
                                                Text(String(weatherData?.current.wind_dir ?? "- -"))
                                            }
                                            .padding(.trailing, 20)
                                            VStack {
                                                Text("Speed:")
                                                Text("\(String(Double(weatherData?.current.wind_mph ?? 0.0))) MPH")
                                            }
                                            .padding(.trailing, 20)
                                            VStack {
                                                Text("Degree:")
                                                Text(String(Int(weatherData?.current.wind_degree ?? 0)))
                                            }
                                            .padding(.trailing, 20)
                                            VStack {
                                                Text("Gust Speed:")
                                                Text("\(String(Double(weatherData?.current.gust_mph ?? 0.0))) MPH")
                                            }
                                        }
                                        .padding([.top,.bottom,.leading,.trailing], 20)
                                        .font(.system(size: 20))
                                    }
                                    .padding(.bottom, 50)
                                }
                                
                                .frame(width: 350, height: 160)
                                .foregroundColor(.white)
                                
                            }
                            .padding(.bottom, 20)
                            Spacer()
                        }
                        
                    }
                }
                .onAppear(){
                    Task{
                        weatherData = await weatherModel.apiCall(cityName: weatherModel.coordinateString!)
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

