//
//  ListView.swift
//  WeatherApp
//
//  Created by Adam Ress on 6/9/24.
//

import SwiftUI

struct ListView: View {
    
    @Environment(WeatherModel.self) var weatherModel
    
    @State var currentDataArray: [[Any]] = []
    
    @State var boolDataLoaded = false
    
    @State private var selectedMeasurement = "fahrenheit"
    
    @State private var isSearching = false
    @State private var searchText = ""
    @FocusState private var isSearchFieldFocused: Bool
    
    
    var body: some View {
        
        if isSearching {
            ZStack {
                Color.black.opacity(0.5)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        self.isSearching = false
                    }
                
                VStack {
                    HStack {
                        TextField("Search for a city or airport", text: $searchText)
                            .focused($isSearchFieldFocused)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                            .padding(.leading)
                        
                        Button("Cancel") {
                            self.isSearching = false
                            self.searchText = ""
                            self.isSearchFieldFocused = false
                        }
                        .shadow(color: .white, radius: 15)
                        .padding(.trailing)
                    }
                    Spacer()
                }
                .frame(height: 300)
            }
        }
        else {
            VStack {
                
                Picker("", selection: $selectedMeasurement) {
                    Text("Fahrenheit").tag("fahrenheit")
                    Text("Celsius").tag("celsius")
                }
                .pickerStyle(SegmentedPickerStyle())
                .foregroundStyle(.black)
                .padding(.horizontal, 30)
                .onChange(of: selectedMeasurement) { _, newValue in
                    weatherModel.setSelectedMeasurement(value: newValue)
                }
                
                Button(action: {
                    self.isSearching = true
                    self.isSearchFieldFocused = true
                }) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                        Text("Search for a city or airport")
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                }
                .padding([.horizontal, .top])
                .padding(.bottom, -25)
                
                if boolDataLoaded {
                    
                    List(weatherModel.cityNames, id: \.self) { city in
                        if let index = weatherModel.cityNames.firstIndex(of: city) {
                            if let name = currentDataArray[index][0] as? String,
                               let temp = currentDataArray[index][1] as? Double,
                               let maxTemp = currentDataArray[index][2] as? Double,
                               let minTemp = currentDataArray[index][3] as? Double {
                                
                                
                                WeatherBlockView(name: name, temperature: Int(temp), maxTemp: Int(maxTemp), minTemp: Int(minTemp))
                                    .padding(.horizontal, -30)
                                    .padding(.vertical, -20)
                                
                                
                            } else {
                                Text("Error: Data type mismatch")
                            }
                        }
                    }
                    .scrollContentBackground(.hidden)
                }
                else {
                    LoadingView()
                        .onAppear {
                            Task {
                                for city in weatherModel.cityNames {
                                    let temporaryModel = await weatherModel.apiCall(cityName: city)
                                    
                                    if let model = temporaryModel {
                                        
                                        var dataArray = []
                                        dataArray.append(model.location.name ?? "")
                                        dataArray.append(model.current.temp_f ?? 0)
                                        dataArray.append(model.forecast.forecastday[0].day?.maxtemp_f ?? 0)
                                        dataArray.append(model.forecast.forecastday[0].day?.mintemp_f ?? 0)
                                        
                                        currentDataArray.append(dataArray)
                                    }
                                }
                                
                                boolDataLoaded = true
                            }
                        }
                }
            }
            .onAppear() {
                selectedMeasurement = weatherModel.getSelectedMeasurement()
            }

        }
    }
}

#Preview {
    ListView()
        .environment(WeatherModel())
}
