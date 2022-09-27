//
//  HourlyWeatherScrollView.swift
//  Clothes By Weather
//
//  Created by Jiyoung Park on 2022/09/25.
//

import SwiftUI
import WeatherKit

struct HourlyWeatherScrollView: View {
    @State var weather: Weather
    
    let startHour: Int
    let endHour: Int
    let currentDate: Date
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                HourlyWeatherView(time: "Now", imageName: weather.currentWeather.symbolName, temperature: weather.currentWeather.temperature.value, isActive: isActive(hourString: Calendar.current.dateComponents([.hour], from: Date.now).hour?.formatted() ?? ""))
                ForEach(weather.hourlyForecast.filter { $0.date > currentDate }.prefix(24), id: \.date) { hourlyWeather in
                    VStack {
                        HourlyWeatherView(time: Calendar.current.dateComponents([.hour], from: hourlyWeather.date).hour?.formatted() ?? "", imageName: hourlyWeather.symbolName, temperature: hourlyWeather.temperature.value, isActive: isActive(hourString: Calendar.current.dateComponents([.hour], from: hourlyWeather.date).hour?.formatted() ?? ""))
                    }
                }
            }
            .padding(20)
        }
        .background(RoundedRectangle(cornerRadius: 19).foregroundColor(Color("Box")))
    }
    
    private func isActive(hourString: String) -> Bool {
        if let hour = Int(hourString) {
            if hour >= startHour && hour <= endHour { return true }
        }
        return false
    }
}

struct HourlyWeatherView: View {
    let time: String
    let imageName: String
    let temperature: Double
    let isActive: Bool
    
    var body: some View {
        VStack(spacing: 10) {
            Text(time)
            Image(systemName: "\(imageName).fill")
                .frame(height: 20)
            Text("\(Int(temperature))°")
                .font(.custom(FontManager.Pretendard.regular, size: 15))
                .padding(.top, 2)
        }
        .foregroundColor(isActive ? Color("Main") : Color("Serve2"))
        .frame(width: 50)
        .font(.custom(FontManager.Pretendard.semiBold, size: 16))
    }
}
