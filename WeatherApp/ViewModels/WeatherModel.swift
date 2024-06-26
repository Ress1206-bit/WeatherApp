//
//  weatherModel.swift
//  WeatherApp
//
//  Created by Adam Ress on 6/1/24.
//

import Foundation
import CoreLocation

@Observable
class WeatherModel: NSObject, CLLocationManagerDelegate {

    var cityNames: [String] {
        get {
            return UserDefaults.standard.array(forKey: "cityNames") as? [String] ?? ["33.93, -84.37", "25.77, -80.19", "48.87, 2.33", "-54.84, -68.3"]
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "cityNames")
        }
    }
    
    private var selectedMeasurement: String {
        get {
            return UserDefaults.standard.string(forKey: "selectedMeasurement") ?? "fahrenheit"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "selectedMeasurement")
        }
    }
    
    var currentUserLocation: CLLocationCoordinate2D?
    
    var locationManager = CLLocationManager()
    var coordinateString: String?
    
    var temporarySelectedMeasurement = "fahrenheit"

    override init() {
        super.init()
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.delegate = self
        
        // Load saved location if available
        if let locationDict = UserDefaults.standard.dictionary(forKey: "currentUserLocation") as? [String: Double],
           let latitude = locationDict["latitude"],
           let longitude = locationDict["longitude"] {
            currentUserLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
    }
    
    func apiCall(cityName: String) async -> CurrentData? {
        let apiKey = "660bf5506b9c4285b82181711243105"
        
        // Make URL
        if let url = URL(string: "https://api.weatherapi.com/v1/forecast.json?key=\(apiKey)&q=\(cityName)&days=3&aqi=no&alerts=no") {
            
            // Make request
            let request = URLRequest(url: url)
            
            // URL session
            do {
                let (data, _) = try await URLSession.shared.data(for: request)
                
                // Parse JSON
                let decoder = JSONDecoder()
                do {
                    let response = try decoder.decode(CurrentData.self, from: data)
                    return response
                } catch {
                    print(error)
                }
            } catch {
                print(error)
            }
        }
        return nil
    }
    
    func getWeatherView(currentData: CurrentData) -> WeatherView {
        return WeatherView(weatherData: currentData)
    }
    
    func getUserLocation() {

        // Checks that we have permission
        if locationManager.authorizationStatus == .authorizedWhenInUse {
            currentUserLocation = nil
            locationManager.requestLocation()
        }
        else {
            locationManager.requestWhenInUseAuthorization()
        }


    }

    func locationManager( _ manager: CLLocationManager, didFailWithError error: any Error) {
        print(error)
    }

    func locationManagerDidChangeAuthorization( _ manager: CLLocationManager) {
        //Detect if user allowed location
        if manager.authorizationStatus == .authorizedWhenInUse {

            currentUserLocation = nil
            manager.requestLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        currentUserLocation = locations.last?.coordinate

        coordinateString = "\(currentUserLocation?.latitude ?? 0),\(currentUserLocation?.longitude ?? 0)"

        manager.stopUpdatingLocation()
    }
    
    func formatDateHourly(_ dateString: String) -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        inputFormatter.timeZone = TimeZone(secondsFromGMT: 0) // Adjust this if the date strings are in a different time zone

        if let date = inputFormatter.date(from: dateString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "h:mm a"
            outputFormatter.amSymbol = "AM"
            outputFormatter.pmSymbol = "PM"
            outputFormatter.timeZone = TimeZone(secondsFromGMT: 0) // Same as input time zone

            let formattedDate = outputFormatter.string(from: date)
            return formattedDate
        } else {
            return nil
        }
    }
    
    func formatDateDaily(_ dateString: String) -> String? {
        // Create a date formatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        // Convert the input string to a Date object
        guard let date = dateFormatter.date(from: dateString) else {
            return nil
        }
        
        // Change the date formatter to output the day of the week
        dateFormatter.dateFormat = "EEE"
        
        // Convert the date back to a string
        let dayOfWeekString = dateFormatter.string(from: date)
        
        return dayOfWeekString
    }
    
    func conditionCodeIntoSFSymbol(code: Int, isDaytime: Bool) -> String {
        var sf = ""
        switch code {
        case 1000: // clear
            sf = isDaytime ? "sun.max.fill" : "moon.stars.fill"
        case 1003: // partly cloudy
            sf = isDaytime ? "cloud.sun.fill" : "cloud.moon.fill"
        case 1006: // cloudy
            sf = "cloud.fill"
        case 1009: // overcast
            sf = "smoke.fill"
        case 1030, 1135, 1147: // misty, fog, freezing fog
            sf = "cloud.fog.fill"
        case 1063: // patchy rain
            sf = isDaytime ? "cloud.sun.rain.fill" : "cloud.moon.rain.fill"
        case 1066, 1210, 1213, 1216, 1219, 1222, 1225, 1255, 1258: // patchy snow, patchy light snow, light snow, patchy moderate snow, moderate snow, patchy heavy snow, heavy snow, light snow showers, moderate or heavy snow showers
            sf = "cloud.snow.fill"
        case 1069, 1204, 1207, 1249, 1252: // patchy sleet, light sleet, moderate or heavy sleet, light sleet showers, moderate or heavy sleet showers
            sf = "cloud.sleet.fill"
        case 1072, 1150, 1153, 1168, 1171, 1180, 1198, 1240: // patchy freezing drizzle, patchy light drizzle, light drizzle, freezing drizzle, heavy freezing drizzle, patchy light rain, light freezing rain, light rain shower
            sf = "cloud.drizzle.fill"
        case 1087: // thundery outbreaks
            sf = "cloud.bolt.fill"
        case 1114, 1117: // blowing snow, blizzard
            sf = "wind.snow"
        case 1183, 1186, 1189: // light rain, moderate rain at times, moderate rain
            sf = "cloud.rain.fill"
        case 1192, 1195, 1201, 1243, 1246: // heavy rain at times, heavy rain, moderate or heavy freezing rain, moderate or heavy rain shower, torrential rain shower
            sf = "cloud.heavyrain.fill"
        case 1237, 1261, 1264: // ice pellets, light showers of ice pellets, moderate or heavy showers of ice pellets
            sf = "cloud.hail.fill"
        case 1273, 1276, 1279, 1282: // patchy light rain with thunder, moderate or heavy rain with thunder, patchy light snow with thunder, moderate or heavy snow with thunder
            sf = "cloud.bolt.rain.fill"
        default:
            sf = "sun.max.trianglebadge.exclamationmark.fill"
        }
        return sf
    }
    
    func conditionCodeIntoBg(code: Int, isDaytime: Bool) -> String {
        var bg = ""
        switch code {
        case 1000: // clear
            bg = isDaytime ? "sunny sky" : "night sky"
        case 1003: // partly cloudy
            bg = isDaytime ? "partly cloudy day" : "partly cloudy night"
        case 1006: // cloudy
            bg = isDaytime ? "cloudy" : "partly cloudy night"
        case 1009, 1030, 1135, 1147: // overcast, misty, fog, freezing fog
            bg = "overcast"
        case 1063: // patchy rain
            bg = isDaytime ? "rain light" : "rain dark"
        case 1066, 1210, 1213, 1216, 1219, 1222, 1225, 1255, 1258: // patchy snow, patchy light snow, light snow, patchy moderate snow, moderate snow, patchy heavy snow, heavy snow, light snow showers, moderate or heavy snow showers
            bg = "snow"
        case 1069, 1204, 1207, 1249, 1252: // patchy sleet, light sleet, moderate or heavy sleet, light sleet showers, moderate or heavy sleet showers
            bg = "snow"
        case 1072, 1150, 1153, 1168, 1171, 1180, 1198, 1240: // patchy freezing drizzle, patchy light drizzle, light drizzle, freezing drizzle, heavy freezing drizzle, patchy light rain, light freezing rain, light rain shower
            bg = isDaytime ? "rain light" : "rain dark"
        case 1114, 1117: // blowing snow, blizzard
            bg = "snow"
        case 1183, 1186, 1189: // light rain, moderate rain at times, moderate rain
            bg = isDaytime ? "rain light" : "rain dark"
        case 1192, 1195, 1201, 1243, 1246: // heavy rain at times, heavy rain, moderate or heavy freezing rain, moderate or heavy rain shower, torrential rain shower
            bg = isDaytime ? "rain light" : "rain dark"
        case 1237, 1261, 1264: // ice pellets, light showers of ice pellets, moderate or heavy showers of ice pellets
            bg = "snow"
        case 1273, 1276, 1279, 1282, 1087: // patchy light rain with thunder, moderate or heavy rain with thunder, patchy light snow with thunder, moderate or heavy snow with thunder
            bg = "thunderstorm"
        default:
            bg = "sunny sky"
        }
        return bg
    }
    
    func isDaytime(currTime: String, sunriseTime: String, sunsetTime: String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        guard let current = dateFormatter.date(from: currTime),
              let sunrise = dateFormatter.date(from: sunriseTime),
              let sunset = dateFormatter.date(from: sunsetTime) else {
            return false
        }
        
        return current >= sunrise && current <= sunset
    }
    
    func setSelectedMeasurement(value: String) {
        UserDefaults.standard.set(value, forKey: "selectedMeasurement")
    }
    
    func getSelectedMeasurement() -> String {
        return selectedMeasurement
    }
    
    func getCoordinateString() -> String {
        return coordinateString ?? ""
    }
    
    func convertToCelsius(temperature: Int) -> Int {
        if temporarySelectedMeasurement == "celsius" {
            let celsius = (temperature - 32) * 5 / 9
            return celsius
        }
        
        return temperature
    }
}
