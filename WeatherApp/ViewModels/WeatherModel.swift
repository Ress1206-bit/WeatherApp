//
//  weatherModel.swift
//  WeatherApp
//
//  Created by Adam Ress on 6/1/24.
//

import Foundation

@Observable
class WeatherModel {
    
    var cityNames: [String] = ["Atlanta", "London"]
    
    var currentData: [CurrentData] = []
    
    func addWeatherData(cityName: String) {
        Task {
            await currentData.append(apiCall(cityName: cityName))
        }
    }
    
    func apiCall(cityName: String) async -> CurrentData {
        let apiKey = "660bf5506b9c4285b82181711243105"
        
        //make url
        if let url = URL(string: "https://api.weatherapi.com/v1/forecast.json?key=\(apiKey)&q=\(cityName)&days=3&aqi=no&alerts=no") {
            
            //make request
            let request = URLRequest(url: url)
            //request.addValue(apiKey, forHTTPHeaderField: "key")
            
            //url session
            do {
                let (data, _) = try await URLSession.shared.data(for: request)
                
                //parse json
                let decoder = JSONDecoder()
                do {
                    let response = try decoder.decode(CurrentData.self, from: data)
                    return response
                }
                catch {
                    print(error)
                }
            }
            catch {
                print(error)
            }
        }
        return currentData[0]
    }
    
    func getWeatherView(index: Int) -> WeatherView {
 
        
        let name:String? = cityNames[index]
        let temperature: Double? = currentData[index].current.temp_f
        let weatherDescription: String? = currentData[index].current.condition?.text
        let maxTemp: Double? = currentData[index].forecast.forecastday[0].day?.maxtemp_f
        let minTemp: Double? = currentData[index].forecast.forecastday[0].day?.mintemp_f
        
        
        
        let weatherView = WeatherView(name: name,
                                      temperature: Int(temperature ?? 0),
                                      weatherDescription: weatherDescription,
                                      maxTemp: Int(maxTemp ?? 0),
                                      minTemp: Int(minTemp ?? 0))
        
        return weatherView
        
    }
    
    func loadWeatherData() {
        for cityName in cityNames {
            addWeatherData(cityName: cityName)
        }
    }
}


