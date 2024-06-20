//
//  ListView.swift
//  WeatherApp
//
//  Created by Adam Ress on 6/9/24.
//

import SwiftUI

struct ListView: View {
    
    @Environment(WeatherModel.self) var weatherModel
    @Environment(CityModel.self) var cityModel
    
    @State var currentDataArray: [[Any]] = []
    
    @State var boolDataLoaded = false
    
    @State private var selectedMeasurement = "fahrenheit"
    
    @State private var isSearching = false
    @State private var searchText = ""
    @FocusState private var isSearchFieldFocused: Bool
    
    @State var cityInfoArr: [[String?]] = []
    
    
    @State var cityNames: [String] = []
    
    @State var boolGivenCityNames: Bool = false
    
    @State private var showAlert = false
    
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
                        TextField("Search for a city", text: $searchText)
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
                    
                    
                    Divider()
                        .overlay(.white)
                    
                    ScrollView {
                        if cityInfoArr.count > 0 {
                            ForEach(cityInfoArr, id:\.self) { cityInfo in
                                HStack {
                                    Button(action: {
                                        
                                        if(cityNames.contains(cityInfo[0]!) || cityNames.contains(cityInfo[3]!)) {
                                            showAlert = true
                                        }
                                        else {
                                            cityNames.append(cityInfo[3]!)
                                            weatherModel.cityNames.append(cityInfo[3]!)
                                            self.isSearching = false
                                            self.searchText = ""
                                            self.isSearchFieldFocused = false
                                        }
                                    }, label: {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 15)
                                                .foregroundStyle(Color(.systemGray6))
                                                .frame(height: 50)
                                                .environment(\.colorScheme, .dark)
                                            HStack {
                                                if cityInfo[2]! == "United States of America" {
                                                    Text("\(cityInfo[0]!), \(cityInfo[1]!), USA")
                                                        .font(.system(size: 16))
                                                        .foregroundStyle(.white)
                                                        .padding(.leading)
                                                }
                                                else {
                                                    Text("\(cityInfo[0]!), \(cityInfo[2]!)")
                                                        .font(.system(size: 16))
                                                        .foregroundStyle(.white)
                                                        .padding(.leading)
                                                }
                                                Spacer()
                                            }
                                        }
                                    })
                                    .alert(isPresented: $showAlert) {
                                        Alert(
                                            title: Text("Already Exists"),
                                            message: Text("You currently have this location's weather"),
                                            dismissButton: .default(Text("Okay"))
                                        )
                                    }
                                    
                                    Spacer()
                                }
                                .padding(.horizontal, 20)
                                .padding(.vertical, 2)
                            }
                        }
                        else {
                            ZStack {
                                RoundedRectangle(cornerRadius: 15)
                                    .foregroundStyle(Color(.systemGray6))
                                    .frame(height: 50)
                                    .environment(\.colorScheme, .dark)
                                HStack {
                                    Text("No results found, refine your search.")
                                        .foregroundStyle(.white)
                                        .padding(.leading)
                                    Spacer()
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 2)
                        }
                    }
                    .scrollIndicators(.visible)
                    
                    Spacer()
                }
                .frame(maxHeight: 350)
                
            }
            .onAppear() {
                boolDataLoaded = false
            }
            .onChange(of: searchText) {
                Task {
                    if let result: [Cities?] = await cityModel.getCities(cityName: searchText) {
                        cityModel.setCityInfoArr(cityList: result)
                        cityInfoArr = cityModel.getCityInfoArr()
                    }
                }
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
                    weatherModel.temporarySelectedMeasurement = newValue
                }
                
                Button(action: {
                    self.isSearching = true
                    self.isSearchFieldFocused = true
                }) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                        Text("Search for a city")
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                }
                .padding(.horizontal)
                .padding(.top, 25)
                
                if boolDataLoaded {
                    
                    NavigationStack {
                        List(cityNames, id: \.self) { city in
                            if let index = cityNames.firstIndex(of: city),
                               index < currentDataArray.count,
                               let name = currentDataArray[index][0] as? String,
                               let temp = currentDataArray[index][1] as? Double,
                               let maxTemp = currentDataArray[index][2] as? Double,
                               let minTemp = currentDataArray[index][3] as? Double,
                               let imageName = weatherModel.conditionCodeIntoBg(
                                code: currentDataArray[index][4] as? Int ?? 0,
                                isDaytime: weatherModel.isDaytime(
                                    currTime: currentDataArray[index][5] as? String ?? "",
                                    sunriseTime: currentDataArray[index][6] as? String ?? "",
                                    sunsetTime: currentDataArray[index][7] as? String ?? ""
                                )) as? String {
                                
                                
                                WeatherBlockView(name: name, temperature: Int(temp), maxTemp: Int(maxTemp), minTemp: Int(minTemp), imageName: imageName)
                                    .padding(.horizontal, -30)
                                    .padding(.vertical, -20)
                                    .swipeActions(edge: .trailing) {
                                        Button(role: .destructive) {
                                            cityNames.remove(at: index)
                                            weatherModel.cityNames = cityNames
                                            currentDataArray.remove(at: index)
                                        } label: {
                                            Label("Delete", systemImage: "trash")
                                        }
                                    }
                                
                                
                            } else {
                                Text("Error: Data type mismatch")
                            }
                        }
                        .listStyle(.plain)
                        .scrollContentBackground(.hidden)
                        .padding(.horizontal, 15)
                        
                    }
                    .navigationTitle("My Places")
                }
                else {
                    LoadingView()
                        .onAppear {
                            
                            currentDataArray.removeAll()
                            
                            Task {
                                for city in cityNames {
                                    let temporaryModel = await weatherModel.apiCall(cityName: city)
                                    
                                    if let model = temporaryModel {
                                        
                                        var dataArray = []
                                        dataArray.append(model.location.name ?? "")
                                        dataArray.append(model.current.temp_f ?? 0)
                                        dataArray.append(model.forecast.forecastday[0].day?.maxtemp_f ?? 0)
                                        dataArray.append(model.forecast.forecastday[0].day?.mintemp_f ?? 0)
                                        dataArray.append(model.current.condition?.code ?? 0)
                                        dataArray.append(weatherModel.formatDateHourly(model.location.localtime ?? "0000-00-00 01:00 AM") ?? "01:00 AM")
                                        dataArray.append(model.forecast.forecastday[0].astro?.sunrise ?? "00:00 AM")
                                        dataArray.append(model.forecast.forecastday[0].astro?.sunset ?? "24:00 PM")
                                        
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
                
                if !boolGivenCityNames {
                    cityNames = weatherModel.cityNames
                    boolGivenCityNames = true
                }
            }

        }
    }
}

#Preview {
    ListView()
        .environment(WeatherModel())
        .environment(CityModel())
}
