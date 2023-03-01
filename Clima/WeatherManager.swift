//
//  WeatherManager.swift
//  Clima
//
//  Created by MacBook on 01.03.2023.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=3aa4ca9c1555ba5bb6de5e222cede661&units=metric"
//    "https://api.openweathermap.org/geo/1.0/direct?limit=5&appid=3aa4ca9c1555ba5bb6de5e222cede661"
    func feachWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(urlString: urlString)
    }
    func performRequest(urlString: String) {
        //1. Создать URL-адрес
        if let url = URL(string: urlString) {
            //2. Создать URL-сессию
            let session = URLSession (configuration: .default)
            //3. Дать задание сессии
            let task = session.dataTask(with: url, completionHandler: handle(data:responce:error:))
            //4. Выполнить задание
            task.resume()
        }

    }
    func handle (data: Data?, responce: URLResponse?, error: Error?){
        if error != nil {
            print(error!)
            return
        }
        
        if let safeData = data {
            let dataString = String(data: safeData, encoding: .utf8)
            print(dataString )
        }
    }
}
