//
//  Weather.swift
//  Clima
//
//  Created by MSOL on 24/03/2025.
//

import Foundation

struct Weather: Decodable {
    let coord: Coordinates
    let weather: [WeatherInfo]
    let base: String
    let main: MainWeather
    let visibility: Int
    let wind: Wind
    let clouds: Cloud
    let dt: Int
    let timezone: Int
    let id: Int
    let name: String
    let cod: Int
    let sys: Sys 
}

struct Coordinates: Decodable {
    let lon: Double
    let lat: Double
}

struct WeatherInfo: Decodable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct MainWeather: Decodable {
    let temp: Double
    let feelsLiks: Double
    let tempMin: Double
    let tempMax: Double
    let pressure: Int
    let humidity: Int
    let seaLevel: Int
    let grndLevel: Int
    
    enum CodingKeys: String, CodingKey{
        case temp, pressure, humidity
        case feelsLiks = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
    }
}

struct Wind: Decodable {
    let speed: Double?
    let deg: Int?
    let gust: Double?
}

struct Cloud: Decodable {
    let all: Int
}
struct Sys: Decodable {
    let type: Int?
    let id: Int?
    let country: String
    let sunrise: Int
    let sunset: Int
}

