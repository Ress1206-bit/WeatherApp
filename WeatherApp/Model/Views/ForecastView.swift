//
//  ForecastView.swift
//  WeatherApp
//
//  Created by Avi Nebel on 6/7/24.
//

import SwiftUI

struct ForecastView: View {
    
    @State private var selectedTab = 0
    @Environment(WeatherModel.self) var weatherModel
    
    var weatherData: CurrentData?
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .frame(width: 350, height: 200)
                .foregroundStyle(.black.opacity(0.35))
                .shadow(color: .white, radius: 50)
            VStack {
                Picker("", selection: $selectedTab) {
                    Text("Hourly").tag(0)
                    Text("Daily").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .foregroundStyle(.black)
                .padding()
                .frame(width: 300)
                
                if selectedTab == 0 {
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack {
                            let currTime = String(weatherModel.formatDateHourly(String(weatherData?.location.localtime ?? "0000-00-00 00:00")) ?? "00")
                            
                            let isDaytimeNow = weatherModel.isDaytime(currTime: currTime, sunriseTime: String(weatherData?.forecast.forecastday[0].astro?.sunrise ?? "00:00 AM"), sunsetTime: String(weatherData?.forecast.forecastday[0].astro?.sunset ?? "24:00 PM"))
                            
                            VStack{
                                Text("Now")
                                    .font(.system(size: 15))
                                    .padding(.top, 4)
                                    .foregroundStyle(.white)
                                Image(systemName: weatherModel.conditionCodeIntoSFSymbol(code: Int(weatherData?.current.condition?.code ?? 0), isDaytime: isDaytimeNow))
                                    .symbolRenderingMode(.multicolor)
                                    .padding(.top, 4)
                                    .frame(height:25)
                                    .scaledToFit()
                                    .font(.system(size: 20))
                                Text(" ")
                                        .font(.system(size: 15))
                                Text("\(Int(weatherData?.current.temp_f ?? 0))°")
                                    .padding(.top, 0.25)
                                    .foregroundStyle(.white)
                                    .fontWeight(.semibold)
                            }
                            .padding(.trailing, 20)
                            .padding(.leading, 10)
                            ForEach(0..<3, id: \.self) { num in
                                if let hourlyData = weatherData?.forecast.forecastday[num].hour?.sorted(by: { $0.time_epoch ?? 0 < $1.time_epoch ?? 1 })  {
                                    
                                    ForEach(hourlyData, id: \.time_epoch) { hour in
                                        if Int(hour.time_epoch ?? 00) > Int(weatherData?.location.localtime_epoch ?? 01) {
                                            let hourTime = String(weatherModel.formatDateHourly(String(hour.time ?? "0000-00-00 00:00")) ?? "00")
                                            
                                            let isDaytime = weatherModel.isDaytime(currTime: hourTime, sunriseTime: String(weatherData?.forecast.forecastday[num].astro?.sunrise ?? "00:00 AM"), sunsetTime: String(weatherData?.forecast.forecastday[num].astro?.sunset ?? "24:00 PM"))
                                            
                                            
                                            VStack{
                                                Text(hourTime)
                                                    .font(.system(size: 15))
                                                    .padding(.top, 4)
                                                    .foregroundStyle(.white)
                                                Image(systemName: weatherModel.conditionCodeIntoSFSymbol(code: Int(hour.condition?.code ?? 0), isDaytime: isDaytime))
                                                    .symbolRenderingMode(.multicolor)
                                                    .padding(.top, 4)
                                                    .frame(height:25)
                                                    .scaledToFit()
                                                    .font(.system(size: 20))

                                                if Int(hour.chance_of_rain ?? 00) > 0 {
                                                    Text("\(Int(hour.chance_of_rain ?? 00))%")
                                                        .foregroundStyle(Color.cyan)
                                                        .font(.system(size: 15))
                                                        .shadow(radius: 10)
                                                } else {
                                                    Text(" ")
                                                        .font(.system(size: 15))
                                                }
                                                Text("\(Int(hour.temp_f ?? 0))°")
                                                    .padding(.top, 0.25)
                                                    .foregroundStyle(.white)
                                                    .fontWeight(.semibold)
                                            }
                                            .padding(.trailing, 20)
                                        }
                                    }
                                } else {
                                    Text("No data available")
                                }
                                    
                                
                                if num != 2 {
                                    Divider()
                                        .frame(width: 2.5, height:70)
                                        .overlay(.white)
                                        .fontWeight(.bold)
                                        .padding(.trailing, 20)
                                }
                            }
                        }
                        .padding([.leading, .trailing], 15)
                    }
                    .frame(width: 350)
                } else {
                        if let dailyData = weatherData?.forecast.forecastday.sorted(by: { $0.date_epoch ?? 0 < $1.date_epoch ?? 1 }) {
                            
                            ForEach(Array(dailyData.enumerated()), id: \.element.date_epoch) { index, dayData in
                                HStack() {
                                    Text(String(weatherModel.formateDateDaily(String(dayData.date ?? "0000-00-00")) ?? "Date Error"))
                                        .frame(maxWidth: 40, alignment: .leading)
                                    Spacer()
                                    Image(systemName: weatherModel.conditionCodeIntoSFSymbol(code: Int(dayData.day?.condition?.code ?? 000), isDaytime: true))
                                        .symbolRenderingMode(.multicolor)
                                        .frame(maxWidth: 40, idealHeight: 20, maxHeight: 20, alignment: .leading)
                                        .scaledToFit()
                                    Spacer()
                                    Text("\(Int(dayData.day?.maxtemp_f ?? 00))º↑ ")
                                        .frame(maxWidth: 50, alignment: .trailing)
                                        .fontWeight(.semibold)
                                    Text("\(Int(dayData.day?.mintemp_f ?? 00))º↓ ")
                                        .frame(maxWidth: 50, alignment: .trailing)
                                    Text("\(String(dayData.day?.daily_chance_of_rain ?? 00))%")
                                        .frame(maxWidth: 50, alignment: .trailing)
                                }
                                .font(.system(size: 18))
                                .padding([.leading,.trailing], 20)
                                .foregroundStyle(.white)
                                
                                if index < dailyData.count - 1 {
                                    Divider()
                                        .frame(width: 300)
                                }
                            }
                            .frame(width: 350)
                        } else {
                            Text("No data available")
                        }
                }
                Spacer()
            }
        }
        .frame(width: 350, height: 200)
    }
}

#Preview {
    ForecastView()
        .environment(WeatherModel())
}
