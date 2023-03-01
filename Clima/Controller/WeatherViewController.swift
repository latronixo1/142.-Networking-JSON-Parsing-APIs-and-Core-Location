//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.delegate = self
        // Do any additional setup after loading the view.
    }

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
            weatherManager.feachWeather(cityName: city)
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

