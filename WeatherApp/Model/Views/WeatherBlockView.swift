//
//  WeatherBlockView.swift
//  WeatherApp
//
//  Created by Adam Ress on 6/9/24.
//

import SwiftUI

struct WeatherBlockView: View {
    
    @State var name: String?
    var temperature: Int?
    var maxTemp: Int?
    var minTemp: Int?
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30)
                .frame(height: 135)
                .padding()
                .foregroundStyle(.blue)
            
            HStack{
                VStack{
                    Text(name ?? "- -")
                        .foregroundStyle(.white)
                        .font(.system(size: 30))
                        .padding(5)
                    Spacer()
                }
                .frame(height: 120)
                
                
                Spacer()
                
                VStack{
                    Text("\(temperature ?? 0)")
                        .foregroundStyle(.white)
                        .font(.system(size: 65))
                    
                    Text("H:\(maxTemp ?? 0)° L:\(minTemp ?? 0)°")
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .padding(.bottom, 20)
                }
            }
            .frame(width: 320)
        }
        
    }
}

#Preview {
    WeatherBlockView()
}
