//
//  ViewController.swift
//  Baluchon
//
//  Created by Lei et Matthieu on 23/07/2018.
//  Copyright © 2018 Mattkee. All rights reserved.
//

import UIKit

class ChangeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        toggleActivityIndicator(shown: false)
        displayAlertDelegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var convertChangeButton: UIButton!
    @IBOutlet weak var currencyToConvert: UITextField!
    @IBOutlet weak var convertedCurrency: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    var displayAlertDelegate: DisplayAlert?
//    var isNoNumberEntry: Bool {
//        if let number = currencyToConvert.text {
//            if number.isEmpty {
//                displayAlertDelegate?.showAlert(title: "pas de nombre", message: "Entrez un nombre correct!")
//                return true
//            } else if String(number) ==  String(Double(currencyToConvert.text)) {
//                displayAlertDelegate?.showAlert(title: "nombre incorrect", message: "Entrez un nombre correct!")
//                return true
//            }
//        }
//        return false
//    }

    @IBAction func convertButton(_ sender: UIButton) {
        toggleActivityIndicator(shown: true)
//        guard !isNoNumberEntry else {
//            toggleActivityIndicator(shown: false)
//            return
//        }
        ChangeService.shared.getChange { (success, change) in
            self.toggleActivityIndicator(shown: false)
            if success {
                let result = ChangeService.shared.changeMoney(changeNeed: (change?.rates["USD"])!, numberNeedToConvert: self.currencyToConvert.text!)
                self.update(resultChange: result)
            } else {
                self.showAlert(title: "Echec Appel réseau", message: "refaire un essai")
                print("ok")
            }
        }
    }
    
    private func toggleActivityIndicator(shown: Bool) {
        activityIndicator.isHidden = !shown
        convertChangeButton.isHidden = shown
    }
    private func update(resultChange: Double) {
        convertedCurrency.text = String(resultChange)
    }
}

// MARK: - Alert Management
extension ChangeViewController: DisplayAlert {
    func showAlert(title: String, message: String) {
        let alerteVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alerteVC.addAction(action)
        present(alerteVC, animated: true, completion: nil)
    }
}
