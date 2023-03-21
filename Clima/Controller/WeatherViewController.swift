//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBAction func currentLocationButton(_ sender: UIButton) {
         locationManager.requestLocation()   // внутри этой функции вызывается locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) или func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) (если ошибок не было или были), поэтому их нужно описать (см. ниже). Для корректной работы (чтобы не выдавалась ошибка Error Domain=kCLErrorDomain Code=0 "(null)") нужно при запущенном симуляторе выбрать через верхнее меню Features - Location - Custom location... (координаты здесь пишутся не с точкой, а с запятой! (не 37.6156, а 37,6156!), и здесь сначала указывается широта, и только потом долгота, в отличие от всех остальных наших мест, например, в результатах JSON-запроса на openweathermap)
     }
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        //locationManager.startUpdatingLocation()   //эта функция используется для периодического отслеживания (например, для навигатора)
        locationManager.requestLocation()
        
        weatherManager.delegate = self
        searchTextField.delegate = self
        // Do any additional setup after loading the view.
    }
}
//MARK: - UITextFieldDelegate
extension WeatherViewController: UITextFieldDelegate {
    //нажатие кнопки с изображением лупы
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
        print(searchTextField.text!)
    }
    
    //функция делегата (в названии есть Should"), которая вызывается в момент нажатия кнопки возврата (в данный момент это кнопка "Go" на экранной клавиатуре)
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
//        print(searchTextField.text!)
        if let city = searchTextField.text {
            weatherManager.fetchWeather(cityName: city)
        }

        return true
    }
    
    //функция делегата (в названии есть "Should") - окончание ввода текст в текстовое поле
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        //если в текстовом поле остался какой-то текст, то возвращаем true
        if textField.text == "" {
            return true
        } else {
            //а если текстовое поле пустое, то вернем false
            textField.placeholder = "Введите что-нибудь"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        //используйте searchTextField для поиска погоды для этого города
//        if let city = searchTextField.text {
//            weatherManager.feachWeather(cityName: city)
//        }
        searchTextField.text = ""   //очищаем строку поиска после нажатия кнопки "Go" на экранной клавиатуре или кнопки с изображением лупы
    }
}

//MARK: - Расширения
extension WeatherViewController: WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, _ weather: WeatherModel) {
        //print(weather.temperature)
        //обновление погоды (через интернет) напрямую на пользовательский запрещено, только посредством диспетчера очереди
        DispatchQueue.main.async {
            //покажем пользователю температуру, иконку погоды и город
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName  
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}
 //MARK: - Расширение местоположения
extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        if let location = locations.last {
            locationManager.stopUpdatingLocation()  //прекратить отслеживать местоположение
            let lat = location.coordinate.latitude  //широта
            let lon = location.coordinate.longitude //долгота
            print(lat)
            print(lon)
            weatherManager.fetchWeather(latitude: String(lat), longitude: String(lon))
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
