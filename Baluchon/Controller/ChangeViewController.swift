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
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var convertChangeButton: UIButton!
    @IBOutlet weak var currencyToConvert: UITextField!
    @IBOutlet weak var convertedCurrency: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var numberNeedToConvert: Double {
        guard currencyToConvert == nil else {
            return 0
        }
        if let number = currencyToConvert.text {
            return Double(number)!
        }
        return 0
    }

    @IBAction func convertButton(_ sender: UIButton) {
        toggleActivityIndicator(shown: true)
        
        
        ChangeService.shared.getChange { (success, change) in
            self.toggleActivityIndicator(shown: false)
            if success, let change = change {
               let reference = ChangeService.shared.searchRate(chosenCurrency: "USD", rateData: change)
                let result = ChangeService.shared.changeMoney(changeNeed: reference, numberNeedToConvert: self.numberNeedToConvert)
                self.update(resultChange: result)
            } else {
               // self.presentAlert()
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

