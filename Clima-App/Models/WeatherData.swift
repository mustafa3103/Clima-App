//
//  WeatherData.swift
//  Clima-App
//
//  Created by Mustafa on 10.01.2022.
//

import Foundation

struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [weather]
    
}

struct Main: Codable {
    let temp: Double
}

struct weather: Codable {
    let id: Int
    let description: String
}
