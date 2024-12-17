//
//  WeatherResponse.swift
//  SnapTag
//
//  Created by Suraj Joshi on 28/09/24.
//

import Foundation

// Root model to decode the WeatherStack response
struct WeatherStackResponse: Codable {
    let request: Request
    let location: Location
    let current: CurrentWeather
}

// Request information (optional, for debugging purposes)
struct Request: Codable {
    let type: String
    let query: String
    let language: String
    let unit: String
}

// Location details
struct Location: Codable {
    let name: String
    let country: String
    let region: String
    let lat: String
    let lon: String
    let timezoneId: String
    let localtime: String
    let localtimeEpoch: Int
    let utcOffset: String

    enum CodingKeys: String, CodingKey {
        case name, country, region, lat, lon
        case timezoneId = "timezone_id"
        case localtime, localtimeEpoch = "localtime_epoch", utcOffset = "utc_offset"
    }
}

// Current weather data
struct CurrentWeather: Codable {
    let observationTime: String
    let temperature: Int
    let weatherCode: Int
    let weatherIcons: [String]
    let weatherDescriptions: [String]
    let windSpeed: Int
    let windDegree: Int
    let windDir: String
    let pressure: Int
    let precip: Int
    let humidity: Int
    let cloudCover: Int
    let feelsLike: Int
    let uvIndex: Int
    let visibility: Int

    enum CodingKeys: String, CodingKey {
        case observationTime = "observation_time"
        case temperature, weatherCode = "weather_code", weatherIcons = "weather_icons"
        case weatherDescriptions = "weather_descriptions", windSpeed = "wind_speed"
        case windDegree = "wind_degree", windDir = "wind_dir", pressure, precip
        case humidity, cloudCover = "cloudcover", feelsLike = "feelslike"
        case uvIndex = "uv_index", visibility
    }
}
