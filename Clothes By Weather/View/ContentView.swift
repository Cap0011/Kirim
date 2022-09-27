//
//  ContentView.swift
//  Clothes By Weather
//
//  Created by Jiyoung Park on 2022/09/23.
//

import SwiftUI
import WeatherKit

struct ContentView: View {
    @Environment(\.scenePhase) var scenePhase

    @StateObject private var locationManager = LocationManager()
    
    @State private var weather: Weather?
    
    @State var isShowingPickerView = false
    
    @State var startHour = 9
    @State var endHour = 18
    
    @State var currentDate = Date.now
    
    @AppStorage("shouldShowOnboarding") var shouldShowOnboarding = true
    
    let weatherService = WeatherService.shared
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Image("bg").resizable().ignoresSafeArea()
            VStack(alignment: .leading) {
                HStack(spacing: 12) {
                    HStack(spacing: 12) {
                        Image(systemName: "pin.fill")
                            .offset(y: 1)
                        Text(locationManager.currentCityName.isEmpty ? "현재 위치" : locationManager.currentCityName)
                    }
                    .padding(.vertical, 6)
                    .padding(.horizontal, 18)
                    .background(Capsule().foregroundColor(Color("Box")).frame(height: 34))
                    
                    Spacer()
                    
                    Text("\(startHour):00 - \(endHour):00")
                        .padding(.vertical, 6)
                        .padding(.horizontal, 18)
                        .background(Capsule().foregroundColor(Color("Box")).frame(height: 34))
                        .onTapGesture {
                            isShowingPickerView.toggle()
                        }
                }
                .font(.custom(FontManager.Pretendard.semiBold, size: 16))
                .foregroundColor(Color("Serve1"))
                .padding(.top, 36)
                
                VStack(spacing: 10) {
                    Text("활동 시간 평균 기온")
                        .font(.custom(FontManager.Pretendard.bold, size: 18))
                    HStack(alignment: .top) {
                        Spacer()
                        if let weather {
                            Text("\(Int(middleValue(weather: weather, startHour: startHour, endHour: endHour)))")
                                .font(.custom(FontManager.Pretendard.bold, size: 80))
                            Image("Oval")
                                .frame(width: 14, height: 14)
                                .offset(x: -6, y: 14)
                        }
                        Spacer()
                    }
                    .offset(x: 7)
                    
                    if weather != nil, let todayWeather = weatherToday(weather: weather!) {
                        HStack(spacing: 2) {
                            Text(todayWeather.condition.description)
                            Image(systemName: "\(todayWeather.symbolName).fill")
                                .foregroundColor(Color("Main"))
                        }
                        
                        HStack(spacing: 0) {
                            Text("최고:\(Int(todayWeather.highTemperature.value)) ")
                            Text("|").opacity(0.5)
                            Text(" 최저:\(Int(todayWeather.lowTemperature.value)) ")
                            Text("|").opacity(0.5)
                            Text(" 강수:\(Int(todayWeather.precipitationChance * 100))%")
                        }
                        .foregroundColor(Color("Serve1"))
                        .font(.custom(FontManager.Pretendard.medium, size: 16))
                    }
                }
                .font(.custom(FontManager.Pretendard.semiBold, size: 16))
                .foregroundColor(Color("Main"))
                .padding(.top, 34)
                
                if let weather {
                    VStack(spacing: 18) {
                        HourlyWeatherScrollView(weather: weather, startHour: startHour, endHour: endHour, currentDate: currentDate)
                            .padding(.top, 20)
                        
                        ClothesView(temperature: middleValue(weather: weather, startHour: startHour, endHour: endHour), currentPage: 0)
                            .padding(.bottom, 36)
                    }
                }
            }
            .padding(.horizontal, 20)
        }
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
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                print("Active")
            } else if newPhase == .inactive {
                print("Inactive")
            } else if newPhase == .background {
                print("Background")
                exit(0)
            }
        }
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
