//
//  WeatherData.swift
//  Hava durumu
//
//  Created by Ferhat Adiyeke on 2.05.2022.
//

import Foundation

struct WeatherData: Codable {
    let coord: Coord
    let weather: [Weather]
    let main: Main
}

struct Coord: Codable {
    let lon: Double
    let lat: Double
}

struct Weather: Codable {
    let main: String
    let description: String
    let icon: String
}

struct Main: Codable {
    let temp: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
    let humidity: Int
}
