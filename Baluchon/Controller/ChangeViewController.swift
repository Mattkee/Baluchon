//
//  ViewController.swift
//  Baluchon
//
//  Created by Lei et Matthieu on 23/07/2018.
//  Copyright © 2018 Mattkee. All rights reserved.
//

import UIKit

class ChangeViewController: UIViewController {
    
    var money : Money?
    var change : Change?
    var nameList = [String]()
    var labelMoneyToConvert = "Euro"
    var labelConvertedMoney = "United States Dollar"

    override func viewDidLoad() {
        super.viewDidLoad()
        displayAlertDelegate = self
        moneyToConvert.setTitle(labelMoneyToConvert, for: .normal)
        convertedMoney.setTitle(labelConvertedMoney, for: .normal)

        refresh()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBOutlet weak var buttonRefresh: UIButton!
    @IBOutlet weak var currencyToConvert: UITextField!
    @IBOutlet weak var convertedCurrency: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var moneyToConvert: UIButton!
    @IBOutlet weak var convertedMoney: UIButton!

    var displayAlertDelegate: DisplayAlert?

    @IBAction func PickerViewAccess(_ sender: Any) {
        performSegue(withIdentifier: "PickerSegue", sender: nil)
    }
    @IBAction func changeValueOne(_ sender: UITextField) {
        guard sender.hasText else {
            return
        }
        let abreviation = ChangeService.shared.searchMoney(moneyName: convertedMoney.currentTitle!, moneyData: money!)
        let result = ChangeService.shared.changeMoney(changeNeed: (change?.rates[abreviation])!, numberNeedToConvert: sender.text!)
        update(result)
    }

    @IBAction func changeValueTwo(_ sender: UITextField) {
        
    }

    @IBAction func refreshButton(_ sender: UIButton) {
        refresh()
    }
    private func refresh() {
        toggleActivityIndicator(shown: true)
        
        ChangeService.shared.getChange { (success, change, money) in
            self.toggleActivityIndicator(shown: false)
            if success {
                self.money = money
                self.change = change

                for (_, name) in (self.money?.symbols)! {
                    self.nameList.append(name)
                }
                self.nameList.sort()

            } else {
                self.showAlert(title: "Echec Appel réseau", message: "rafraichir les données")
                print("ok")
            }
        }
    }
    
    private func toggleActivityIndicator(shown: Bool) {
        activityIndicator.isHidden = !shown
        buttonRefresh.isHidden = shown
    }
    private func update(_ resultChange: Double) {
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

// MARK: - Navigation
extension ChangeViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PickerSegue" {
            let successVC = segue.destination as! FirstPickerViewController
            successVC.nameList = nameList // On passe la donnée via les propriétés
        }
    }
}
