//
//  Temperature.swift
//  Clothes By Weather
//
//  Created by Jiyoung Park on 2022/09/25.
//

import Foundation
import WeatherKit

enum Temperature: String, CaseIterable {
    case first = "4°C 이하"
    case second = "5 - 8°C"
    case third = "9 - 11°C"
    case fourth = "12 - 16°C"
    case fifth = "17 - 19°C"
    case sixth = "20 - 22°C"
    case seventh = "23 - 27°C"
    case eighth = "28°C 이상"
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
    case .first: return "패딩, 두꺼운코트, 목도리, 기모"
    case .second: return "코트, 가죽자켓, 히트텍, 니트, 레깅스"
    case .third: return "트렌치 코트, 야상, 자켓, 니트, 청바지, 스타킹"
    case .fourth: return "가디건, 자켓, 야상, 스타킹, 청바지, 면바지"
    case .fifth: return "맨투맨, 후드티, 얇은니트, 가디건, 청바지"
    case .sixth: return "긴팔, 셔츠, 얇은 가디건, 면바지, 청바지"
    case .seventh: return "반팔, 얇은 셔츠, 반바지, 면바지"
    case .eighth: return "민소매, 반팔, 반바지, 원피스"
    }
}

func middleValue(weather: Weather, startHour: Int, endHour: Int) -> Double {
    let todayWeathers = weather.hourlyForecast.filter { Calendar.current.isDateInToday($0.date) && Calendar.current.dateComponents([.hour], from: $0.date).hour! >= startHour && Calendar.current.dateComponents([.hour], from: $0.date).hour! <= endHour }
    var tempArr = [Double]()
    for hourlyWeather in todayWeathers {
        tempArr.append(hourlyWeather.temperature.value)
    }
    tempArr.sort()
    return tempArr.count % 2 == 0 ? (tempArr[tempArr.count / 2] + tempArr[tempArr.count / 2 - 1]) / 2 : tempArr[tempArr.count / 2]
}


func weatherToday(weather: Weather) -> DayWeather? {
    let weather = weather.dailyForecast.filter { Calendar.current.isDateInToday($0.date) }
    if weather.count > 0 { return weather.first }
    else { return nil }
}
