//
//  ClothesWidget.swift
//  ClothesWidget
//
//  Created by Jiyoung Park on 2022/09/24.
//

import CoreLocation
import WeatherKit
import WidgetKit
import SwiftUI

class WidgetLocationManager: NSObject, CLLocationManagerDelegate {
    var locationManager = CLLocationManager()
//    private let geoCoder = CLGeocoder()
    
    private var handler: ((CLLocation) -> Void)?
    
    override init() {
        super.init()
        DispatchQueue.main.async {
            self.locationManager.delegate = self
            if self.locationManager.authorizationStatus == .notDetermined {
                self.locationManager.requestWhenInUseAuthorization()
            }
        }
    }
    
    func fetchLocation(handler: @escaping (CLLocation) -> Void) {
        self.handler = handler
        self.locationManager.requestLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.handler!(locations.last!)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
//    func fetchCityName(location: CLLocation) async -> String {
//        do {
//            var currentCityName = ""
//            let placemarks = try await geoCoder.reverseGeocodeLocation(location)
//            placemarks.forEach { placemark in
//                if let city = placemark.locality { currentCityName = city }
//            }
//            return currentCityName
//        } catch {
//            print(error.localizedDescription)
//        }
//        return ""
//    }
}

struct Provider: TimelineProvider {
    var widgetLocationManager = WidgetLocationManager()
    
    func placeholder(in context: Context) -> WeatherEntry {
        WeatherEntry(date: Date(), averageTemperatureString: "21", weatherDescription: "Cloudy", temperatureString: Temperature.sixth.rawValue, clothesString: properClothes(for: Temperature.sixth), imageName: imageName(for: Temperature.sixth), weatherSymbolName: "cloud.moon.bolt", authorizedAlways: true)
    }

    func getSnapshot(in context: Context, completion: @escaping (WeatherEntry) -> ()) {
        let entry = WeatherEntry(date: Date(), averageTemperatureString: "21", weatherDescription: "Cloudy", temperatureString: Temperature.sixth.rawValue, clothesString: properClothes(for: Temperature.sixth), imageName: imageName(for: Temperature.sixth), weatherSymbolName: "cloud.moon.bolt", authorizedAlways: true)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let status = widgetLocationManager.locationManager.authorizationStatus
        let currentDate = Date()
        let refreshDate = Calendar.current.date(byAdding: .hour, value: 1, to: currentDate)
        
        if status != .authorizedAlways {
            let entry = WeatherEntry(date: currentDate, averageTemperatureString: "", weatherDescription: "", temperatureString: "", clothesString: "", imageName: "", weatherSymbolName: "", authorizedAlways: false)
            let timeline = Timeline(entries: [entry], policy: .after(refreshDate!))
            completion(timeline)
        } else {
            widgetLocationManager.fetchLocation(handler: { location in
                Task {
                    var startHour = 0
                    var endHour = 0
                    
                    if let groupUserDefaults = UserDefaults(suiteName: "group.HY8Y957QK3.com.jio.weatherwidget") {
                        startHour = groupUserDefaults.integer(forKey: "startHour")
                        endHour = groupUserDefaults.integer(forKey: "endHour")
                        
                        if startHour == endHour {
                            startHour = 9
                            endHour = 18
                        }
                    }
                    
                    if let weather = try? await WeatherService.shared.weather(for: location) {
                        let middleValue = Int(middleValue(weather: weather, startHour: startHour, endHour: endHour))
                        let idx = temperatureIndex(for: middleValue)
                        let type = Temperature.allCases[idx]
                        let todayWeather = weatherToday(weather: weather)
                        
                        let entry = WeatherEntry(date: currentDate, averageTemperatureString: "\(middleValue)", weatherDescription: todayWeather?.condition.description ?? "", temperatureString: type.rawValue, clothesString: properClothes(for: type), imageName: imageName(for: type), weatherSymbolName: todayWeather?.symbolName ?? "", authorizedAlways: true)
                        let timeline = Timeline(entries: [entry], policy: .after(refreshDate!))
                        completion(timeline)
                    }
                }
            })
        }
    }
}

struct WeatherEntry: TimelineEntry {
    let date: Date
    
    let averageTemperatureString: String
    let weatherDescription: String
    let temperatureString: String
    let clothesString: String
    let imageName: String
    let weatherSymbolName: String
    
    let authorizedAlways: Bool
}

struct ClothesWidgetEntryView : View {
    @Environment(\.widgetFamily) private var widgetFamily
    var entry: Provider.Entry

    var body: some View {
        ZStack(alignment: .topLeading) {
            Color("WidgetBackground")
            if !entry.authorizedAlways {
                Text("위젯 사용을 위해 '설정 > Kirim > 위치 > 항상'을 선택해주세요!")
                    .font(.custom(FontManager.Pretendard.semiBold, size: 14))
                    .foregroundColor(Color("Main"))
                    .padding(20)
                    .lineSpacing(5)
            } else {
                switch widgetFamily {
                case .systemSmall:
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Today")
                            .foregroundColor(Color("Point"))
                        Text(entry.temperatureString)
                            .foregroundColor(Color("Serve1"))
                            .padding(.bottom, 10)
                        
                        Text(entry.clothesString)
                            .font(.custom(FontManager.Pretendard.semiBold, size: 14))
                            .foregroundColor(Color("Main"))
                            .lineSpacing(5)
                    }
                    .font(.custom(FontManager.Pretendard.bold, size: 15))
                    .padding(17)
                case .systemMedium:
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 10) {
                            Text("Today")
                                .foregroundColor(Color("Point"))
                            Text(entry.temperatureString)
                                .foregroundColor(Color("Serve1"))
                        }
                        
                        Text(entry.clothesString)
                            .font(.custom(FontManager.Pretendard.semiBold, size: 14))
                            .foregroundColor(Color("Main"))
                            .lineSpacing(5)
                        
                        HStack {
                            Spacer()
                            Image(entry.imageName)
                                .resizable()
                                .scaledToFit()
                            Spacer()
                        }
                    }
                    .font(.custom(FontManager.Pretendard.bold, size: 15))
                    .padding(.vertical, 15)
                    .padding(.horizontal, 20)
                case .systemLarge:
                    VStack(alignment: .leading) {
                        Text("활동 시간 평균 기온")
                            .font(.custom(FontManager.Pretendard.bold, size: 18))
                        HStack {
                            HStack {
                                Text(entry.averageTemperatureString)
                                    .font(.custom(FontManager.Pretendard.bold, size: 60))
                                Image("Oval")
                                    .frame(width: 11, height: 11)
                                    .offset(x: -5, y: -20)
                            }
                            
                            HStack(spacing: 2) {
                                Text(entry.weatherDescription)
                                    .font(.custom(FontManager.Pretendard.semiBold, size: 17))
                                Image(systemName: "\(entry.weatherSymbolName).fill")
                            }
                            .foregroundColor(Color("Main"))
                            .offset(y: 12)
                        }
                        
                        Rectangle()
                            .frame(height: 1.5)
                            .foregroundColor(Color("Serve2"))
                            .padding(.bottom, 22)
                            .offset(y: -20)
                            .opacity(0.4)
                        
                        VStack(alignment: .leading, spacing: 10) {
                            HStack(spacing: 10) {
                                Text("Today")
                                    .foregroundColor(Color("Point"))
                                Text(entry.temperatureString)
                                    .foregroundColor(Color("Serve1"))
                            }
                            
                            Text(entry.clothesString)
                                .font(.custom(FontManager.Pretendard.semiBold, size: 16))
                                .foregroundColor(Color("Main"))
                                .lineSpacing(5)
                            
                            Image(entry.imageName)
                                .resizable()
                                .scaledToFit()
                        }
                        .font(.custom(FontManager.Pretendard.bold, size: 16))
                        .padding(.top, -21)
                    }
                    .foregroundColor(Color("Main"))
                    .padding(24)
                default:
                    VStack {}
                }
            }
        }
    }
}

@main
struct ClothesWidget: Widget {
    let kind: String = "ClothesWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            ClothesWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("기온별 옷차림")
        .description("날씨와 기온에 맞는 옷차림을 확인하고, Kirim 앱으로 빠르게 접근합니다.")
    }
}

struct ClothesWidget_Previews: PreviewProvider {
    static var previews: some View {
        ClothesWidgetEntryView(entry: WeatherEntry(date: Date(), averageTemperatureString: "21", weatherDescription: "Cloudy", temperatureString: Temperature.sixth.rawValue, clothesString: properClothes(for: Temperature.sixth), imageName: imageName(for: Temperature.sixth), weatherSymbolName: "cloud.moon.bolt", authorizedAlways: false))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
