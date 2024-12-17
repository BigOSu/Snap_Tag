//
//  WeatherManager.swift
//  SnapTag
//
//  Created by Suraj Joshi on 28/09/24.
//

import CoreLocation
import Foundation

    //
    
import CoreLocation
import Foundation

class WeatherManager {
    private let apiKey = "069cb687a19f54d0656aac79a7bd65b6"
    
    func fetchWeather(for locationName: String, units: String = "m", language: String = "en", completion: @escaping (String) -> Void) {
        let encodedLocation = locationName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        let urlString = "https://api.weatherstack.com/current?access_key=\(apiKey)&query=\(encodedLocation)"
        
        // Ensure URL is valid
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            completion("N/A")
            return
        }
        
        // FETCH WEATHER DATA
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Failed to fetch weather data: \(error)")
                completion("N/A")
                return
            }
            
            guard let data = data else {
                print("No data returned")
                completion("N/A")
                return
            }
            
            do {
                let weatherResponse = try JSONDecoder().decode(WeatherStackResponse.self, from: data)
                
                // Access the current weather details
                let temperature = weatherResponse.current.temperature
                let weatherDescription = weatherResponse.current.weatherDescriptions.first ?? "N/A"
                let humidity = weatherResponse.current.humidity
                let windSpeed = weatherResponse.current.windSpeed
                let pressure = weatherResponse.current.pressure
                let weatherIcon = weatherResponse.current.weatherIcons.first ?? ""

                let weatherString = "\(weatherDescription), \(temperature)°C, Humidity: \(humidity)%, Wind Speed: \(windSpeed) km/h"
                
                completion(weatherString)
            } catch {
                print("Failed to decode JSON: \(error)")
                completion("N/A")
            }

        }.resume()
    }
}
