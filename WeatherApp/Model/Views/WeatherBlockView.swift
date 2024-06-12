//
//  WeatherBlockView.swift
//  WeatherApp
//
//  Created by Adam Ress on 6/9/24.
//

import SwiftUI

struct WeatherBlockView: View {
    
    @Environment(WeatherModel.self) var weatherModel
    
    @State var name: String?
    var temperature: Int?
    var maxTemp: Int?
    var minTemp: Int?
    var imageName: String?
    
    var body: some View {
        ZStack {
            if let imageName = self.imageName {
                Image(imageName)
                    .centerFilled()
                    .clipShape(RoundedRectangle(cornerRadius: 30))
                    .ignoresSafeArea()
                    .frame(height: 135)
                    .padding()
            } else {
                RoundedRectangle(cornerRadius: 30)
                    .frame(height: 135)
                    .padding()
                    .foregroundStyle(.blue)
            }
            
            HStack{
                VStack{
                    Text(name ?? "- -")
                        .foregroundStyle(.white)
                        .font(.system(size: 30))
                        .padding(5)
                        .shadow(color: .black, radius: 11)
                    Spacer()
                }
                .frame(height: 120)
                
                
                Spacer()
                
                VStack{
                    Text("\(weatherModel.convertToCelsius(temperature: temperature ?? 0))")
                        .foregroundStyle(.white)
                        .font(.system(size: 65))
                        .shadow(color: .black, radius: 11)
                    
                    Text("H:\(weatherModel.convertToCelsius(temperature: maxTemp ?? 0))° L:\(weatherModel.convertToCelsius(temperature: minTemp ?? 0))°")
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .padding(.bottom, 20)
                        .shadow(color: .black, radius: 11)
                }
            }
            .frame(width: 320)
        }
        
    }
}

#Preview {
    WeatherBlockView()
}
