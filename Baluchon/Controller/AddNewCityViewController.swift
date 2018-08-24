//
//  AddNewCityViewController.swift
//  Baluchon
//
//  Created by Lei et Matthieu on 22/08/2018.
//  Copyright © 2018 Mattkee. All rights reserved.
//

import UIKit

class AddNewCityViewController: UIViewController {

    // MARK: - Properties
    var weather : Weather?
    var city = [String]()

    // MARK: - Outlets
    @IBOutlet weak var cityStackView: UIStackView!
    @IBOutlet weak var addNewCityButton: UIButton!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityTemp: UILabel!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var searchCityText: UITextField!
}

// MARK: - Action
extension AddNewCityViewController {

    @IBAction func searchCity(_ sender: UITextField) {
        self.cityTemp.isHidden = false
        self.weatherIcon.isHidden = false
        city = [String]()
        city.append(sender.text!)
        WeatherService.shared.getWeather(city: city) { (success, weather) in
            
            if success {
                self.weather = weather
                
                self.cityName.text = weather?.query.results.channel[0].location.city
                let temperature = (weather?.query.results.channel[0].item.condition.temp)!
                self.cityTemp.text = "\(temperature)°C"
                self.weatherIcon.image = UIImage(named: Constant.WeatherConstant.setImage((weather?.query.results.channel[0].item.condition.code)!))
                self.cityStackView.isHidden = false
                self.addNewCityButton.isHidden = false
                
            } else {
                self.showAlert(title: "Echec Appel réseau", message: "rafraichir les données")
            }
        }
    }

    @IBAction func addNewCity(_ sender: UIButton) {
        WeatherViewController.allCity.append(cityName.text!)
        self.cityName.text = "Ville ajoutée"
        self.cityTemp.isHidden = true
        self.weatherIcon.isHidden = true
        self.addNewCityButton.isHidden = true
    }
}

// MARK: - Keyboard
extension AddNewCityViewController: UITextFieldDelegate {
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        searchCityText.resignFirstResponder()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - Alert Management
extension AddNewCityViewController: DisplayAlert {
    func showAlert(title: String, message: String) {
        let alerteVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alerteVC.addAction(action)
        present(alerteVC, animated: true, completion: nil)
    }
}
