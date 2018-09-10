//
//  WeatherViewController.swift
//  Baluchon
//
//  Created by Lei et Matthieu on 16/08/2018.
//  Copyright © 2018 Mattkee. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {

    // MARK: - Properties
    let weatherService = WeatherService()
    static var weather: Weather?
    var allCity = [String]()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        allCity = Constant.allCity
        refresh()
    }
    @IBOutlet weak var tableView: UITableView!
}

// MARK: - Methods
extension WeatherViewController {
    private func refresh() {
        
        weatherService.getWeather(city: allCity) { (error, weather) in
            guard error == nil else {
                guard let error = error else {
                    return
                }
                self.showAlert(title: "Echec Appel réseau", message: error)
                return
            }
            WeatherViewController.weather = weather
            
            self.tableView.reloadData()
        }
    }
    private func removeCity(at index: Int) {
        allCity.remove(at: index)
        Constant.allCity = allCity
    }
}

// MARK: - Tab View Management
extension WeatherViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allCity.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "City", for: indexPath) as? WeatherImage else {
            return UITableViewCell()
        }
        guard let city = WeatherViewController.weather?.query.results.channel[indexPath.row] else {
            return UITableViewCell()
        }
        guard let icon = UIImage(named: weatherService.setImage(city.item.condition.code)) else {
            return UITableViewCell()
        }
        
        cell.configure(withIcon: icon, cityName: city.location.city, temperature: "\(city.item.condition.temp)°C")
        return cell
    }
}
// MARK: - Delete Cell
extension WeatherViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.removeCity(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
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
