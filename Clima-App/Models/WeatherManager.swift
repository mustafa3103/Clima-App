//
//  WeatherManager.swift
//  Clima-App
//
//  Created by Mustafa on 8.01.2022.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager ,weather: WeatherModel)
    func didFailWithError(_ error: Error)
}

struct WeatherManager {
    
    let weatherUrl = "https://api.openweathermap.org/data/2.5/weather?appid=a7e2c19877b779dc05b3a2d9e38b19d5&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherUrl)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherUrl)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    //MARK: - Request Process
    func performRequest(with urlString: String) {
        //1.Create url
        if let url = URL(string: urlString) {
            //2.Create url session
            let session = URLSession(configuration: .default)
            
            //3.Give the session task
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    delegate?.didFailWithError(error!)
                    //Buradaki return'nün olayı bir hata ile karşılaştığı zaman kod bloğunu kes ve bitir fonksiyonu.
                    return
                }
        
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) {
                        
                        self.delegate?.didUpdateWeather(self ,weather: weather)
                        
                    }
                }
            }
            //4.Start the task
            task.resume()
        }
    }
    //MARK: - Turning data to Swift format
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
        
            return weather
            
        } catch {
            delegate?.didFailWithError(error)
           return nil
        }
    }
}
