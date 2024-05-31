//
//  ContentView.swift
//  WeatherApp
//
//  Created by Adam Ress on 5/30/24.
//

import SwiftUI

struct ContentView: View {
    
    @State var currentData: CurrentData?
    
    var body: some View {
        let colors: [Color] = [.red, .blue]
        TabView {
            ForEach(colors, id: \.self) { color in
                VStack {
                    color
                    Text("HIIIIIII")
                }
            }
        }
        .tabViewStyle(.page)
        .onAppear() {
            Task {
                currentData = await apiCall()
            }
        }
        
    }
    
    func apiCall() async -> CurrentData {
        let apiKey = "660bf5506b9c4285b82181711243105"
        
        //make url
        if let url = URL(string: "https://api.weatherapi.com/v1/forecast.json?key=\(apiKey)&q=Atlanta&days=3&aqi=no&alerts=no") {
            
            //make request
            let request = URLRequest(url: url)
            //request.addValue(apiKey, forHTTPHeaderField: "key")
            
            //url session
            do {
                let (data, response) = try await URLSession.shared.data(for: request)
                
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
        return currentData! //if error prolly this lmao 😭 tf is thisssss
    }
}

#Preview {
    ContentView()
}
