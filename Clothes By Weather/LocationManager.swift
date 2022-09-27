//
//  LocationManager.swift
//  Clothes By Weather
//
//  Created by Jiyoung Park on 2022/09/25.
//

import CoreLocation
import Foundation
import WidgetKit

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let geoCoder = CLGeocoder()
    private let manager = CLLocationManager()

    @Published var currentLocation: CLLocation?
    
    @Published var currentCityName = ""

    override init() {
        super.init()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = kCLDistanceFilterNone
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()
        manager.delegate = self
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last, currentLocation == nil else { return }
        self.currentLocation = location
        
        DispatchQueue.main.async {
            self.currentLocation = location
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        //Handle any errors here...
        print(error.localizedDescription)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print("Called")
        WidgetCenter.shared.reloadTimelines(ofKind: "ClothesWidget")
    }
    
    func fetchCityName() {
        if let location = currentLocation {
            geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, _) -> Void in
                placemarks?.forEach { (placemark) in
                    if let city = placemark.locality { self.currentCityName = city }
                }
            })
        }
    }
}
