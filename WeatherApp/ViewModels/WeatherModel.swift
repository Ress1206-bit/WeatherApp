//
//  weatherModel.swift
//  WeatherApp
//
//  Created by Adam Ress on 6/1/24.
//

import Foundation

@Observable
class WeatherModel {
    
    var cityNames: [String] = ["London", "Atlanta"]
    
    func apiCall(cityName: String) async -> CurrentData? {
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
        return nil
    }
    
    func getWeatherView(currentData: CurrentData) -> WeatherView {
        let name:String? = currentData.location.name
        let temperature: Int? = Int(currentData.current.temp_f ?? 0)
        let weatherDescription: String? = currentData.current.condition?.text
        let maxTemp: Int? = Int(currentData.forecast.forecastday[0].day?.maxtemp_f ?? 0)
        let minTemp: Int? = Int(currentData.forecast.forecastday[0].day?.mintemp_f ?? 0)
        
        return WeatherView(name: name,
                           temperature: temperature,
                           weatherDescription: weatherDescription,
                           maxTemp: maxTemp,
                           minTemp: minTemp)
    }
//    
//    func loadWeatherViews() -> [WeatherView] {
//        
//        var weatherViews: [WeatherView] = []
//        
//        for name in cityNames {
//            Task {
//                if let model = await apiCall(cityName: name) {
//                    weatherViews.append(getWeatherView(currentData: model))
//                }
//            }
//        }
//        
//        return weatherViews
//    }
}


