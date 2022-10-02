//
//  Temperature.swift
//  Clothes By Weather
//
//  Created by Jiyoung Park on 2022/09/25.
//

import Foundation
import WeatherKit

enum Temperature: String, CaseIterable {
    case first = "first"
    case second = "second"
    case third = "third"
    case fourth = "fourth"
    case fifth = "fifth"
    case sixth = "sixth"
    case seventh = "seventh"
    case eighth = "eighth"
    
    func localizedString() -> String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
    
    static func getStringFor(string: Temperature) -> String {
        return string.localizedString()
    }
}

func temperatureIndex(for temperature: Int) -> Int {
    switch temperature {
    case ...4: return 0
    case ...8: return 1
    case ...11: return 2
    case ...16: return 3
    case ...19: return 4
    case ...22: return 5
    case ...27: return 6
    case 28...: return 7
    default: return 0
    }
}

func imageName(for temperature: Temperature) -> String {
    switch temperature {
    case .first: return "k8"
    case .second: return "k7"
    case .third: return "k6"
    case .fourth: return "k5"
    case .fifth: return "k4"
    case .sixth: return "k3"
    case .seventh: return "k2"
    case .eighth: return "k1"
    }
}

func properClothes(for temperature: Temperature) -> String {
    switch temperature {
    case .first: return NSLocalizedString("firstClothes", comment: "")
    case .second: return NSLocalizedString("secondClothes", comment: "")
    case .third: return NSLocalizedString("thirdClothes", comment: "")
    case .fourth: return NSLocalizedString("fourthClothes", comment: "")
    case .fifth: return NSLocalizedString("fifthClothes", comment: "")
    case .sixth: return NSLocalizedString("sixthClothes", comment: "")
    case .seventh: return NSLocalizedString("seventhClothes", comment: "")
    case .eighth: return NSLocalizedString("eighthClothes", comment: "")
    }
}

func middleValue(weather: Weather, startHour: Int, endHour: Int) -> Double {
    let todayWeathers = weather.hourlyForecast.filter { Calendar.current.isDateInToday($0.date) && Calendar.current.dateComponents([.hour], from: $0.date).hour! >= startHour && Calendar.current.dateComponents([.hour], from: $0.date).hour! <= endHour }
    var tempArr = [Double]()
    for hourlyWeather in todayWeathers {
        tempArr.append(hourlyWeather.temperature.value)
    }
    let sumArray = tempArr.reduce(0, +)
    return sumArray / Double(tempArr.count)
    // return tempArr.count % 2 == 0 ? (tempArr[tempArr.count / 2] + tempArr[tempArr.count / 2 - 1]) / 2 : tempArr[tempArr.count / 2]
}


func weatherToday(weather: Weather) -> DayWeather? {
    let weather = weather.dailyForecast.filter { Calendar.current.isDateInToday($0.date) }
    if weather.count > 0 { return weather.first }
    else { return nil }
}
