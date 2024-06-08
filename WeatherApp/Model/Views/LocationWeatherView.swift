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
                        Text(currentLocationData?.location.name ?? "- -")
                            .font(.headline)
                            .fontWeight(.medium)
                            .foregroundStyle(.white)
                        ScrollView {
                            Text("\(Int(currentLocationData?.current.temp_f ?? 999))°")
                                .font(.system(size: 100))
                                .fontWeight(.thin)
                                .foregroundStyle(.white)
                                .padding(.leading, 20)
                            Text("Feels Like: \(String(Int(currentLocationData?.current.feelslike_f ?? 999)))º")
                                .foregroundStyle(.white)
                                .fontWeight(.medium)
                            Text("\(currentLocationData?.current.condition?.text ?? "- -")")
                                .fontWeight(.medium)
                                .foregroundStyle(.white)
                            Text("H:\(Int(currentLocationData?.forecast.forecastday[0].day?.maxtemp_f ?? 999))° L:\(Int(currentLocationData?.forecast.forecastday[0].day?.mintemp_f ?? -999))°")
                                .fontWeight(.medium)
                                .foregroundStyle(.white)
                            ZStack{
                                RoundedRectangle(cornerRadius: 15)
                                    .frame(width: 350, height: 160)
                                    .foregroundStyle(.teal)
                                VStack{
                                    Text("Sunny conditions will continue for the rest of the day. Wind gusts are up to 11mph.")
                                        .foregroundStyle(.white)
                                        .font(.system(size: 14))
                                        .padding([.leading, .trailing], 10)
                                        .padding(.top, 10)
                                    Divider()
                                        .overlay(.white)
                                        .padding([.leading,.trailing], 15)
                                    ScrollView(.horizontal, showsIndicators: false){
                                        HStack{
        //                                    ForEach(hourly, id: \.1) { temp in
        //                                        VStack{
        //                                            Text("4pm")
        //                                                .font(.system(size: 13))
        //                                                .padding(.top, 4)
        //                                                .foregroundStyle(.white)
        //                                            Image(systemName: "sun.max.fill")
        //                                                .foregroundStyle(.yellow)
        //                                                .padding(.top, 4)
        //                                                .font(.system(size: 20))
        //                                            Text("\(temp ?? 0)°")
        //                                                .padding(.top, 4)
        //                                                .foregroundStyle(.white)
        //                                        }
        //                                        .padding(.trailing, 20)
        //                                    }
                                        }
                                        .padding([.leading, .trailing], 15)
                                    }
                                    Spacer()
                                }
                                .frame(width: 350, height: 160)
                                
                            }
                            .padding(.top, 40)
                            ZStack {
                                RoundedRectangle(cornerRadius: 15)
                                    .frame(width: 350, height: 160)
                                    .foregroundStyle(.teal)
                                TabView {
                                    HStack {
                                        VStack {
                                            HStack {
                                                Image(systemName: "sunrise.fill")
                                                    .scaleEffect(1.25)
                                                    .symbolRenderingMode(.multicolor)
                                                VStack {
                                                    Text("Sunrise")
                                                        .font(.system(size: 20))
                                                    Text(String(currentLocationData?.forecast.forecastday[0].astro?.sunrise ?? "- -"))
                                                }
                                            }
                                            .padding(2.5)
                                            HStack {
                                                Image(systemName: "sunset.fill")
                                                    .scaleEffect(1.25)
                                                    .symbolRenderingMode(.multicolor)
                                                VStack {
                                                    Text("Sunset")
                                                        .font(.system(size: 20))
                                                    Text(String(currentLocationData?.forecast.forecastday[0].astro?.sunset ?? "- -"))
                                                }
                                            }
                                            .padding(2.5)
                                        }
                                        .padding(.bottom, 15)
                                    }
                                    HStack {
                                        VStack {
                                            HStack {
                                                Image(systemName: "moonrise")
                                                    .scaleEffect(1.25)
                                                VStack {
                                                    Text("Moonrise")
                                                        .font(.system(size: 20))
                                                    Text(String(currentLocationData?.forecast.forecastday[0].astro?.moonrise ?? "- -"))
                                                }
                                            }
                                            .padding(2.5)
                                            HStack {
                                                Image(systemName: "moonset")
                                                    .scaleEffect(1.25)
                                                VStack {
                                                    Text("Moonset")
                                                        .font(.system(size: 20))
                                                    Text(String(currentLocationData?.forecast.forecastday[0].astro?.moonset ?? "- -"))
                                                }
                                            }
                                        }
                                        .padding(2.5)
                                        Spacer()
                                        Spacer()
                                        VStack {
                                            Text("Moon Phase: ")
                                                .font(.system(size: 20))
                                            Image(systemName: "moonphase.\(currentLocationData?.forecast.forecastday[0].astro?.moon_phase?.lowercased().replacingOccurrences(of: " ", with: ".") ?? "new.moon")")
                                                .font(.system(size: 35))
                                                .padding([.top,.bottom], 2.5)
                                            Text(String(currentLocationData?.forecast.forecastday[0].astro?.moon_phase ?? "- -"))
                                                .font(.system(size: 20))
                                        }
                                        Spacer()
                                    }
                                    .padding([.bottom, .leading, .trailing], 15)
                                }
                                .tabViewStyle(.page)
                                .frame(width: 350, height: 160)
                                .foregroundStyle(Color.white)
                            }
                            ZStack {
                                RoundedRectangle(cornerRadius: 15)
                                    .frame(width: 350, height: 160)
                                    .foregroundStyle(.teal)
                                HStack {
                                    Spacer()
                                    Spacer()
                                    VStack {
                                        Text("UV Index:")
                                            .font(.system(size: 20))
                                        Text(String(Int(currentLocationData?.current.uv ?? 999)))
                                            .font(.system(size: 20))
                                            .padding(.bottom, 5)
                                        Image(systemName: "sun.max")
                                            .font(.system(size: 30))
                                    }
                                    Spacer()
                                    VStack {
                                        Text("Humidity:")
                                            .font(.system(size: 20))
                                        Text(String(currentLocationData?.current.humidity ?? 999))
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
                                    .foregroundStyle(.teal)
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
                                                Text(String(currentLocationData?.current.wind_dir ?? "- -"))
                                            }
                                            .padding(.trailing, 20)
                                            VStack {
                                                Text("Speed:")
                                                Text(String(Double(currentLocationData?.current.wind_mph ?? 0.0)))
                                            }
                                            .padding(.trailing, 20)
                                            VStack {
                                                Text("Degree:")
                                                Text(String(Int(currentLocationData?.current.wind_degree ?? 0)))
                                            }
                                            .padding(.trailing, 20)
                                            VStack {
                                                Text("Gust Speed:")
                                                Text(String(Double(currentLocationData?.current.gust_mph ?? 0.0)))
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
                            ZStack { //no extra space below when moved up for some reason, fix?
                                RoundedRectangle(cornerRadius: 15)
                                    .frame(width: 350, height: 200)
                                    .foregroundStyle(.teal)
                                VStack {
                                    Picker("", selection: $selectedTab) {
                                        Text("Hourly").tag(0)
                                        Text("Daily").tag(1)
                                    }
                                    .pickerStyle(SegmentedPickerStyle())
                                    .padding()
                                    .frame(width: 300)
                                    
                                    if selectedTab == 0 {
                                        //replace with scrollview displaying hourly forecast
                                        VStack {
                                            Text("hi")
                                            Text("Hola")
                                        }
                                        .tabItem {
                                            Text("Hourly")
                                        }
                                    } else {
                                        //replace with scrollview for daily forecast
                                        VStack {
                                            Text("yo")
                                            Text("Hola")
                                        }
                                        .tabItem {
                                            Text("Daily")
                                        }
                                    }
                                    Spacer()
                                }
                            }
                            Spacer()
                        }
                        
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

