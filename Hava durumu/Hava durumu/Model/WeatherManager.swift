//
//  WeatherManager.swift
//  Hava durumu
//
//  Created by Ferhat Adiyeke on 2.05.2022.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(manager: WeatherManager, weather: WeatherModel)
    func didFailWithErrors(error: Error)
}

struct WeatherManager {
    internal var delegate: WeatherManagerDelegate?
    private let baseURL = "https://api.openweathermap.org/data/2.5/weather?"
    
    func fetchWeather(lat: CLLocationDegrees, lon: CLLocationDegrees) {
        let urlString = "\(baseURL)&units=metric&appid=\(apiKey)&lat=\(lat)&lon=\(lon)&lang=tr"
        performRequest(with: urlString)
    }
    
    func fetchWeather(for city: String) {
        let urlString = "\(baseURL)q=\(city)&units=metric&appid=\(apiKey)&lang=tr"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!.localizedDescription)
                } else {
                    if let safeData = data {
                        if let weather = self.parseData(safeData) {
                            self.delegate?.didUpdateWeather(manager: self, weather: weather)
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseData(_ data: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: data)
            let temp = decodedData.main.temp
            let description = decodedData.weather[0].description
            let minTemp = decodedData.main.temp_min
            let maxTemp = decodedData.main.temp_max
            let humidity = decodedData.main.humidity
            let feelsLike = decodedData.main.feels_like
            let weatherIcon = decodedData.weather[0].icon
            let weather = WeatherModel(temp: temp, description: description, minTemp: minTemp, maxTemp: maxTemp, humidity: humidity, feelsLike: feelsLike, card: weatherIcon)
            return weather
        } catch {
            delegate?.didFailWithErrors(error: error)
            return nil
        }
    }
}
