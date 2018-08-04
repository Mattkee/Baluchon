//
//  ViewController.swift
//  Baluchon
//
//  Created by Lei et Matthieu on 23/07/2018.
//  Copyright © 2018 Mattkee. All rights reserved.
//

import UIKit

class ChangeViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var money : Money?
    var change : Change?
    var nameList = [String]()
    var labelMoneyToConvert = "Euro"
    var labelConvertedMoney = "United States Dollar"

    override func viewDidLoad() {
        super.viewDidLoad()
        displayAlertDelegate = self

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
    @IBOutlet weak var secondActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var pickerViewMoneyToConvert: UIPickerView!
    @IBOutlet weak var pickerViewConvertedMoney: UIPickerView!

    var displayAlertDelegate: DisplayAlert?
//    var delegate: Delegate?

    @IBAction func changeValueOne(_ sender: UITextField) {
        selectedPickerText()
        changeValueText(labelMoneyToConvert, labelConvertedMoney, money!, sender)
    }

    @IBAction func changeValueTwo(_ sender: UITextField) {
        selectedPickerText()
        changeValueText(labelConvertedMoney, labelMoneyToConvert, money!, sender)
    }

    @IBAction func refreshButton(_ sender: UIButton) {
        refresh()
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        convertedCurrency.resignFirstResponder()
        currencyToConvert.resignFirstResponder()
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.nameList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.nameList[row]
    }

    private func refresh() {
        toggleActivityIndicator(shown: true)
        nameList = [String]()

        ChangeService.shared.getChange { (success, change, money) in
            self.toggleActivityIndicator(shown: false)
            
            if success {
                self.money = money
                self.change = change

                for (_, name) in (self.money?.symbols)! {
                    self.nameList.append(name)
                }
                self.nameList.sort()
                self.pickerViewMoneyToConvert.reloadComponent(0)
                self.pickerViewConvertedMoney.reloadComponent(0)
                self.pickerViewMoneyToConvert.selectRow(self.nameList.index(of: "Euro")!, inComponent: 0, animated: false)
                self.pickerViewConvertedMoney.selectRow(self.nameList.index(of: "United States Dollar")!, inComponent: 0, animated: false)

            } else {
                self.showAlert(title: "Echec Appel réseau", message: "rafraichir les données")
                print("ok")
            }
        }
    }
    private func changeValueText(_ moneyToConvertName: String, _ moneyConvertedName: String, _
        moneyData: Money, _ sender: UITextField) {
        guard sender.hasText else {
            return
        }
        let abreviationOne = ChangeService.shared.searchMoney(moneyName: moneyToConvertName, moneyData: money!)
        print(abreviationOne)
        let abreviationTwo = ChangeService.shared.searchMoney(moneyName: moneyConvertedName, moneyData: money!)
        
        let result = ChangeService.shared.changeMoney(changeNeed: (change?.rates[abreviationTwo])!, numberNeedToConvert: sender.text!, moneySelectedValueForOneEuro: (change?.rates[abreviationOne])!)
        let textField : UITextField
        if sender == convertedCurrency {
            textField = currencyToConvert
        } else {
            textField = convertedCurrency
        }
        update(result, textField)
    }

    private func selectedPickerText() {
        let chosenCurrencyOne = pickerViewMoneyToConvert.selectedRow(inComponent: 0)
        labelMoneyToConvert = nameList[chosenCurrencyOne]
        let chosenCurrencyTwo = pickerViewConvertedMoney.selectedRow(inComponent: 0)
        labelConvertedMoney = nameList[chosenCurrencyTwo]
    }

    private func toggleActivityIndicator(shown: Bool) {
        activityIndicator.isHidden = !shown
        buttonRefresh.isHidden = shown
        secondActivityIndicator.isHidden = !shown
        pickerViewMoneyToConvert.isHidden = shown
        pickerViewConvertedMoney.isHidden = shown
    }

    private func update(_ resultChange: Double,_ textFieldToDisplay: UITextField) {
        textFieldToDisplay.text = String(resultChange)
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
