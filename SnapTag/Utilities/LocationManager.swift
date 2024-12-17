//
//  LocationManager.swift
//  SnapTag
//
//  Created by suraj Sunvera on 15/12/24.
//

import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var manager = CLLocationManager()
    private var locationCallback: ((CLLocation?, Error?) -> Void)?
    
    func requestLocation(completion: @escaping (CLLocation?, Error?) -> Void) {
        locationCallback = completion
        manager.delegate = self
        
        let status = CLLocationManager.authorizationStatus()
        if status == .notDetermined {
            manager.requestWhenInUseAuthorization()
        } else if status == .denied || status == .restricted {
            completion(nil, NSError(domain: "LocationError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Location permissions are denied."]))
            return
        }
        
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .denied || status == .restricted {
            locationCallback?(nil, NSError(domain: "LocationError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Location permissions are denied."]))
        } else if status == .authorizedWhenInUse || status == .authorizedAlways {
            manager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        locationCallback?(locations.first, nil)
        locationCallback = nil
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationCallback?(nil, error)
        locationCallback = nil
    }
}

