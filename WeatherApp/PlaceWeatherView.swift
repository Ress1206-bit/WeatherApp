//
//  PlaceWeatherView.swift
//  WeatherApp
//
//  Created by Adam Ress on 5/30/24.
//

import SwiftUI

struct PlaceWeatherView: View {
    
    var name:String = "Sandy Springs"
    var temperature: Int = 82
    var weatherDescription: String = "Sunny"
    
    var body: some View {
        
        ZStack{
            Rectangle()
                .foregroundStyle(.blue)
                .ignoresSafeArea()
            VStack {
                Text(name)
                    .font(.largeTitle)
                    .fontWeight(.medium)
                    .foregroundStyle(.white)
                    .padding(.top, 50)
                Text("\(temperature)°")
                    .font(.system(size: 100))
                    .fontWeight(.thin)
                    .foregroundStyle(.white)
                    .padding(.leading, 20)
                Text("\(weatherDescription)")
                    .fontWeight(.medium)
                    .foregroundStyle(.white)
                Text("H:82° L:58°")
                    .fontWeight(.medium)
                    .foregroundStyle(.white)
                ZStack{
                    Rectangle()
                        .frame(width: 350, height: 160)
                        .cornerRadius(15)
                        .foregroundStyle(.teal)
                    VStack{
                        Text("Sunny conditions will continue for the rest of the day. Wind gusts are up to 11mph.")
                            .foregroundStyle(.white)
                            .font(.system(size: 14))
                            .padding([.leading, .trailing], 10)
                            .padding(.top, 10)
                        Divider()
                            .overlay(.white)
                            .padding(.leading, 15)
                        ScrollView(.horizontal, showsIndicators: false){
                            HStack{
                                ForEach(0..<10){ index in
                                    VStack{
                                        Text("4pm")
                                            .font(.system(size: 13))
                                            .padding(.top, 4)
                                            .foregroundStyle(.white)
                                        Image(systemName: "sun.max.fill")
                                            .foregroundStyle(.yellow)
                                            .padding(.top, 4)
                                            .font(.system(size: 20))
                                        Text("\(temperature)°")
                                            .padding(.top, 4)
                                            .foregroundStyle(.white)
                                    }
                                    .padding(.trailing, 20)
                                }
                            }
                            .padding([.leading, .trailing], 15)
                        }
                        Spacer()
                    }
                    .frame(width: 350, height: 160)
                    
                }
                .padding(.top, 55)
                Spacer()
                
            }
        }

    }
}

#Preview {
    PlaceWeatherView()
}
