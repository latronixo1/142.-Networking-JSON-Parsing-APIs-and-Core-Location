//
//  WeatherManager.swift
//  Clima
//
//  Created by MacBook on 01.03.2023.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, _ weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=3aa4ca9c1555ba5bb6de5e222cede661&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func feachWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(urlString)
    }
    func performRequest(_ urlString: String) {
        //1. Создать URL-адрес
        if let url = URL(string: urlString) {
            //2. Создать URL-сессию
            let session = URLSession (configuration: .default)
            //3. Дать задание сессии
            let task = session.dataTask(with: url) { data, responce, error in
                if error != nil {
                    //print(error!)
                    delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
//                    let dataString = String(data: safeData, encoding: .utf8)
                    if let weather = self.parseJSON(safeData) {
//                        let weatherVC = WeatherVeiwController()
//                        weatherVC.didUpdateWeather(weather)
                        
                        //====================================================
                        //сделаем то же при помощи делегата
                        self.delegate?.didUpdateWeather(self, weather)
                    }
                }
            }
            //let task = session.dataTask(with: url, completionHandler: handle(data:responce:error:))
            //4. Выполнить задание
            task.resume()
        }

    }
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder ()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            //print(weather.temperatureString)
            return weather
            
//            print(weather.temperature)    // в соответствии с иерархией как внутри полученного JSON-запроса, так и нашими структурами, подписанными на протокол Decodable
//            print(decodedData.weather[0].description)
//            print(decodedData.weather[0].id)
//            print(weather.conditionName)
//            print(weather.temperatureString)
            //conditionImageView.image = getConditionName(weatherId: id)
        } catch {
            //print(error)
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
 }
