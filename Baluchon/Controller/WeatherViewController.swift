//
//  WeatherViewController.swift
//  Baluchon
//
//  Created by Lei et Matthieu on 16/08/2018.
//  Copyright © 2018 Mattkee. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {

    var weather: Weather?
    var weatherIcon: [WeatherIcon]?

    override func viewDidLoad() {
        super.viewDidLoad()
        refresh()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    
    private func refresh() {
        
        WeatherService.shared.getWeather { (success, weather, weatherIcon) in
            
            if success {
                self.weatherIcon = weatherIcon
                self.weather = weather
                self.cityLabel.text = weather?.query.results.channel[0].location.city
                if let temp = weather?.query.results.channel[0].item.condition.temp {
                    self.temperatureLabel.text = "\(temp)°C"
                }
                print("c'est super")
            } else {
                self.showAlert(title: "Echec Appel réseau", message: "rafraichir les données")
                print("ok")
            }
        }
    }
}

// MARK: - Alert Management
extension WeatherViewController: DisplayAlert {
    func showAlert(title: String, message: String) {
        let alerteVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alerteVC.addAction(action)
        present(alerteVC, animated: true, completion: nil)
    }
}
