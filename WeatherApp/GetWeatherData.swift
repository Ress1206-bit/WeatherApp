//
//  GetWeatherData.swift
//  WeatherApp
//
//  Created by Avi Nebel on 5/30/24.
//

import Foundation

struct Wrapper: Codable {
    let current: WeatherData
}

struct WeatherData: Codable {
    let temp: Double
    let feels_like: Double
}

struct dataService {
    func callAPI() {
        let URLString = "https://api.openweathermap.org/data/3.0/onecall?lat=33.44&lon=-94.04&exclude=hourly,daily&appid={API key}"
        let url = URL(string: URLString)
        
        guard url != nil else {
            return
        }
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url!) { data, responseObject, error in
            //check errors
            if error == nil && data != nil {
                //parse
                let decoder = JSONDecoder()
                do {
                    let wrappedWeather = try decoder.decode(Wrapper.self, from: data!);
                    print(wrappedWeather)
                }
                catch {
                    print("error in json parsing :(")
                }
            }
        }
        
        //make api call actually
        dataTask.resume()
    }
}

