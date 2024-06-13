//
//  CityModel.swift
//  WeatherApp
//
//  Created by Avi Nebel on 6/11/24.
//

import Foundation

@Observable
class CityModel {
    
    private var cityInfoArr: [[String?]] = []
    
    func getCities(cityName: String) async -> [Cities?]? {
        let apiKey = "660bf5506b9c4285b82181711243105"
        
        //make url
        if let url = URL(string: "https://api.weatherapi.com/v1/search.json?key=\(apiKey)&q=\(cityName)") {
            
            //make request
            let request = URLRequest(url: url)
            
            //url session
            do {
                let (data, _) = try await URLSession.shared.data(for: request)
                
                //parse json
                let decoder = JSONDecoder()
                do {
                    let response = try decoder.decode([Cities].self, from: data)
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
    
    func setCityInfoArr(cityList: [Cities?]) {
        cityInfoArr.removeAll()
        for city in cityList {
            var cityInfo = [String(city?.name ?? "Unknown Name"), String(city?.region ?? "Unknown Region"), String(city?.country ?? "Unknown Country")]
            let coordinateString = "\(city?.lat ?? 0), \(city?.lon ?? 0)"
            
            cityInfo.append(coordinateString)
            
            cityInfoArr.append(cityInfo)
        }
    }
    
    func getCityInfoArr() -> [[String?]] {
        return cityInfoArr
    }
}
