//
//  ContentView.swift
//  WeatherApp
//
//  Created by Adam Ress on 5/30/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        let colors: [Color] = [.red, .blue]
        TabView {
            ForEach(colors, id: \.self) { color in
                VStack {
                    color
                }
            }
        }
        .tabViewStyle(.page)
        .onAppear() {
            dataService.callAPI(dataService)
        }
        
    }
}

#Preview {
    ContentView()
}
