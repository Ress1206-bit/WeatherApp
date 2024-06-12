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
                    Image(weatherModel.conditionCodeIntoBg(code:  Int(weatherData?.current.condition?.code ?? 0), isDaytime: weatherModel.isDaytime(currTime: String(weatherModel.formatDateHourly(String(weatherData?.location.localtime ?? "0000-00-00 00:00")) ?? "01:00 AM"), sunriseTime: String(weatherData?.forecast.forecastday[0].astro?.sunrise ?? "00:00 AM"), sunsetTime: String(weatherData?.forecast.forecastday[0].astro?.sunset ?? "24:00 PM"))))
                        .centerFilled()
                        .clipShape(.rect())
                        .ignoresSafeArea()
                    
                    VStack {
                        
                        HStack {
                            Spacer()
                            
                            NavigationLink(destination: ListView()) {
                                Image(systemName: "list.bullet")
                                    .shadow(color: /*@START_MENU_TOKEN@*/.black/*@END_MENU_TOKEN@*/, radius: 11)
                                    .foregroundStyle(.white)
                                    .font(.system(size: 30))
                                    .padding(.trailing, 25)
                            }
                        }
                        
                        Text(weatherData?.location.name ?? "- -")
                            .shadow(color: .black, radius: 11)
                            .font(.largeTitle)
                            .fontWeight(.medium)
                            .foregroundStyle(.white)
                            .padding(.top, 15)
                        if weatherData?.location.country == "United States of America" {
                            Text("\(weatherData?.location.region ?? "- -"), USA")
                                .shadow(color: .black, radius: 11)
                                .font(.headline)
                                .fontWeight(.medium)
                                .foregroundStyle(.white)
                        } else {
                            Text(weatherData?.location.country ?? "- -")
                                .shadow(color: .black, radius: 11)
                                .font(.headline)
                                .fontWeight(.medium)
                                .foregroundStyle(.white)
                        }
                        ScrollView {
                            Text("\(weatherModel.convertToCelsius(temperature: Int(weatherData?.current.temp_f ?? 999)))°")
                                .shadow(color: .black, radius: 11)
                                .font(.system(size: 100))
                                .fontWeight(.thin)
                                .foregroundStyle(.white)
                                .padding(.leading, 20)
                            Text("Feels Like: \(String(weatherModel.convertToCelsius(temperature: Int(weatherData?.current.feelslike_f ?? 999))))º")
                                .shadow(color: .black, radius: 11)
                                .foregroundStyle(.white)
                                .fontWeight(.medium)
                            Text("\(weatherData?.current.condition?.text ?? "- -")")
                                .shadow(color: .black, radius: 11)
                                .fontWeight(.medium)
                                .foregroundStyle(.white)
                            Text("H:\(weatherModel.convertToCelsius(temperature: Int(weatherData?.forecast.forecastday[0].day?.maxtemp_f ?? 999)))° L:\(weatherModel.convertToCelsius(temperature: Int(weatherData?.forecast.forecastday[0].day?.mintemp_f ?? -999)))°")
                                .shadow(color: .black, radius: 11)
                                .fontWeight(.medium)
                                .foregroundStyle(.white)
                                .padding(.bottom, 50)
                            ForecastView(weatherData: weatherData)
                            ZStack {
                                RoundedRectangle(cornerRadius: 15)
                                    .frame(width: 350, height: 160)
                                    .foregroundStyle(.black.opacity(0.35))
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
                                    .foregroundStyle(.black.opacity(0.35))
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
                                    .foregroundStyle(.black.opacity(0.35))
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

