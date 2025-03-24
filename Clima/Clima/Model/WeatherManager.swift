//
//  WeatherManager.swift
//  Clima
//
//  Created by MSOL on 24/03/2025.
//

import Foundation

struct WeatherManager {
    //For lat lon, https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={API key}

    private let baseURL = "https://api.openweathermap.org/data/2.5/weather?units=metric&lang=en&appid=5c134350059fec950d7f9c911441096a"
    //MARK: - delegate is the one who is notified
    weak var delegate: WeatherManagerDelegate?
    
    func fetchWeather(for city: String) {
        let urlString = "\(baseURL)&q=\(city)"
        performRequest(with: urlString)
       
    }
    
    func fetchWeather(latitude lat: Double,longitude lon: Double) {
        let urlString = "\(baseURL)&lat=\(lat)&lon=\(lon)"
        performRequest(with: urlString)
    }
    
    private func performRequest(with urlString: String) {
        if let url =  URL(string: urlString) {
            let urlRequest = URLRequest(url: url)
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    //represents any networking-related errors that may occur while making the request.
                    //[No Internet Connection, Timed Out, Network Unavailable, Bad URL, Server Down, Invalid Response]
                    print("Error Fetching , \(error.localizedDescription)")
                    delegate?.didFailWithError(error)
                    return
                }
                
                if let safeData = data {
                    if let dataString = String(data: safeData, encoding: .utf8) {
                        print("Data String: ",dataString)
                    }
                    if let weather = parseJson(safeData) {
                        delegate?.didUpdateWeather(weather)
                    }
                }
            }
            task.resume() // they begin in suspend state.
        } else {
            print("Wrong URL !!!!")
        }
    }
    
    private func parseJson(_ weatherData: Data) -> WeatherModel? {
        do {
            let decoder = JSONDecoder()
            let decodedWeather = try decoder.decode(Weather.self, from: weatherData)
            let weatherModel = WeatherModel(conditionId: decodedWeather.weather[0].id, cityName: decodedWeather.name, temprature: decodedWeather.main.temp)
            return weatherModel
        } catch {
            print("Error Decoding Data: \(error)")
            delegate?.didFailWithError(error)
            return nil
        }
    }
    
   /*
    this is the closure ->
    private func handle(data: Data?, response: URLResponse?, error: Error?) -> Void {
        if let error = error {
            print("Error Fetching, ",error)
            return
        }
        if let safeData = data {
            if let dataString = String(data: safeData, encoding: .utf8) {
                print("Data String: ",dataString)
            }
        }
    }*/
}


/*
 Networking
 1-Create a URL
 2- create a URLSession
 3- Give URLSession a task
 4- start el task
 */
