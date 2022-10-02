//
//  ContentView.swift
//  Clothes By Weather
//
//  Created by Jiyoung Park on 2022/09/23.
//

import SwiftUI
import WeatherKit
import WidgetKit

struct ContentView: View {
    @Environment(\.scenePhase) var scenePhase

    @StateObject private var locationManager = LocationManager()
    
    @State private var weather: Weather?
    
    @State var isShowingPickerView = false
    
    @State var startHour = 9
    @State var endHour = 18
    
    @State var currentDate = Date.now
    
    @State var averageTemperature = 0.0
    
    @AppStorage("shouldShowOnboarding") var shouldShowOnboarding = true
    
    let weatherService = WeatherService.shared
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .topLeading) {
                Image("bg").resizable().ignoresSafeArea()
                VStack(alignment: .leading) {
                    HStack(spacing: 12) {
                        HStack(spacing: 12) {
                            Image(systemName: "pin.fill")
                                .offset(y: 1)
                            if locationManager.currentCityName.isEmpty {
                                Text("currentLocation")
                            } else {
                                Text(locationManager.currentCityName)
                            }
                        }
                        .foregroundColor(Color("Serve1"))
                        .padding(.vertical, 6)
                        .padding(.horizontal, 18)
                        .background(Capsule().foregroundColor(Color("Box")).frame(height: 34))
                        
                        Spacer()
                        
                        Text("\(startHour):00 - \(endHour):00")
                            .padding(.vertical, 6)
                            .padding(.horizontal, 18)
                            .background(Capsule().foregroundColor(Color("Serve1")).frame(height: 34).shadow(color: .black.opacity(0.1), radius: 6, x: 3, y: 3))
                            .onTapGesture {
                                isShowingPickerView.toggle()
                            }
                    }
                    .offset(y: 2)
                    .font(.custom(FontManager.Pretendard.semiBold, size: 16))
                    .foregroundColor(Color("Box"))
                    
                    VStack(spacing: 10) {
                        Text("average")
                            .font(.custom(FontManager.Pretendard.bold, size: 18))
                            .multilineTextAlignment(.center)
                        HStack(alignment: .top) {
                            Spacer()
                            if weather != nil {
                                Text("\(Int(averageTemperature))")
                                    .font(.custom(FontManager.Pretendard.bold, size: 80))
                                Image("Oval")
                                    .frame(width: 14, height: 14)
                                    .offset(x: -6, y: 14)
                            }
                            Spacer()
                        }
                        .offset(x: 7)
                        
                        if weather != nil, let todayWeather = weatherToday(weather: weather!) {
                            HStack(spacing: 3) {
                                Text(todayWeather.condition.description)
                                Image(systemName: "\(todayWeather.symbolName).fill")
                                    .foregroundColor(Color("Main"))
                            }
                            .font(.custom(FontManager.Pretendard.medium, size: 15))
                            .padding(.top, -1)
                            
                            HStack(spacing: 0) {
                                Text("highest")
                                Text(" \(Int(todayWeather.highTemperature.value))°   ")
                                Text("lowest")
                                Text(" \(Int(todayWeather.lowTemperature.value))°   ")
                                Image(systemName: "cloud.rain.fill")
                                    .font(.system(size: 13))
                                    .offset(y: 1)
                                Text(" \(Int(todayWeather.precipitationChance * 100))%")
                            }
                            .foregroundColor(Color("Serve1"))
                            .font(.custom(FontManager.Pretendard.medium, size: 15))
                            .offset(y: -1)
                        }
                    }
                    .font(.custom(FontManager.Pretendard.semiBold, size: 16))
                    .foregroundColor(Color("Main"))
                    .padding(.top, 34)
                    
                    if let weather {
                        VStack(spacing: 18) {
                            HourlyWeatherScrollView(weather: weather, startHour: startHour, endHour: endHour, currentDate: currentDate)
                                .padding(.top, 18)
                            
                            ClothesView(temperature: $averageTemperature, currentPage: temperatureIndex(for: Int(averageTemperature)), todayIndex: temperatureIndex(for: Int(averageTemperature)))
                                .padding(.bottom, 39)
                                .padding(.top, -2)
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: SettingView()) {
                        Label("Setting", systemImage: "gearshape.fill")
                            .font(.system(size: 16))
                            .foregroundColor(Color("Serve1"))
                    }
                }
            }
            .navigationTitle("")
            .fullScreenCover(isPresented: $shouldShowOnboarding) {
                OnboardingView(shouldShowOnboarding: $shouldShowOnboarding)
            }
            .task(id: locationManager.currentLocation) {
                await update()
            }
            .sheet(isPresented: $isShowingPickerView) {
                ActiveTimePicker(isShowingPickerView: $isShowingPickerView, startHour: $startHour, endHour: $endHour, selectedStartHour: startHour, selectedEndHour: endHour)
                    .presentationDetents([.fraction(0.4)])
            }
            .onChange(of: startHour) { startHour in
                if let weather {
                    averageTemperature = middleValue(weather: weather, startHour: startHour, endHour: endHour)
                }
            }
            .onChange(of: endHour) { endHour in
                if let weather {
                    averageTemperature = middleValue(weather: weather, startHour: startHour, endHour: endHour)
                }
            }
            .onChange(of: scenePhase) { newPhase in
                if newPhase == .active {
                    WidgetCenter.shared.reloadTimelines(ofKind: "ClothesWidget")
                } else if newPhase == .inactive {
                } else if newPhase == .background {
                    exit(0)
                }
            }
        }
        .accentColor(Color("Main"))
        
    }
    
    private func update() async {
        if let groupUserDefaults = UserDefaults(suiteName: "group.HY8Y957QK3.com.jio.weatherwidget") {
            startHour = groupUserDefaults.integer(forKey: "startHour")
            endHour = groupUserDefaults.integer(forKey: "endHour")
            
            if startHour == endHour {
                startHour = 9
                endHour = 18
            }
        }
        
        do {
            if let location = locationManager.currentLocation {
                self.weather = try await weatherService.weather(for: location)
                locationManager.fetchCityName()
                if let weather {
                    averageTemperature = middleValue(weather: weather, startHour: startHour, endHour: endHour)
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
