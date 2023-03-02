//
//  WeatherData.swift
//  Clima
//
//  Created by MacBook on 01.03.2023.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation

//каждая структура, предназначенная для хранения данных из результатов JSON-запроса должна быть подписана на протокол Decodable
struct WeatherData: Codable {   //Codable - это Typealias, т.е. всевдоним типа, который заменяет сразу два протокола - Decodable и Encodable
    let name: String
    let main: Main
    let weather: [Weather]  //это когда в результате JSON-запроса есть массив, состоящий из одного элемента:
    /*"weather": [
        {
            "id": 804,              //идентификатор погоды в соответствии с перечнем https://openweathermap.org/weather-conditions
            "main": "Clouds",       //облака
            "description": "overcast clouds",   //пасмурно, облачно
            "icon": "04n"
        }
    ],*/
}

struct Main: Codable {
    let temp: Double
}
struct Weather: Codable {
    let description: String
    let id: Int
}
