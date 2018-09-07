//
//  ViewController.swift
//  Baluchon
//
//  Created by Lei et Matthieu on 23/07/2018.
//  Copyright © 2018 Mattkee. All rights reserved.
//

import UIKit

class ChangeViewController: UIViewController {
    
    let changeService = ChangeService()
    // MARK: - Properties
    var money : Money?
    var change : Change?
    var nameList = [String]()
    var labelMoneyToConvert = "Euro"
    var labelConvertedMoney = "United States Dollar"

    var displayAlertDelegate: DisplayAlert?

    // MARK: - Outlets
    @IBOutlet weak var buttonRefresh: UIBarButtonItem!
    @IBOutlet weak var currencyToConvert: UITextField!
    @IBOutlet weak var convertedCurrency: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var secondActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var pickerViewMoneyToConvert: UIPickerView!
    @IBOutlet weak var pickerViewConvertedMoney: UIPickerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        displayAlertDelegate = self
        refresh()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - Network call action
extension ChangeViewController {
    private func refresh() {
        toggleActivityIndicator(shown: true)
        nameList = [String]()
        
        changeService.getChange { (error, change, money) in
            self.toggleActivityIndicator(shown: false)
            guard error == nil else {
                self.showAlert(title: "Echec Appel réseau", message: error!)
                return
            }
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
        }
    }

    private func toggleActivityIndicator(shown: Bool) {
        activityIndicator.isHidden = !shown
        secondActivityIndicator.isHidden = !shown
        pickerViewMoneyToConvert.isHidden = shown
        pickerViewConvertedMoney.isHidden = shown
    }
}

// MARK: - Display preparation and result
extension ChangeViewController {
    private func changeValueText(_ moneyToConvertName: String, _ moneyConvertedName: String, _
        moneyData: Money, _ sender: UITextField) {
        guard sender.hasText else {
            return
        }
        let abreviationOne = changeService.searchMoney(moneyName: moneyToConvertName, moneyData: money!)
        
        let abreviationTwo = changeService.searchMoney(moneyName: moneyConvertedName, moneyData: money!)
        
        let result = changeService.changeMoney(changeNeed: (change?.rates[abreviationTwo])!, numberNeedToConvert: sender.text!, moneySelectedValueForOneEuro: (change?.rates[abreviationOne])!)
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
    
    private func update(_ resultChange: Double,_ textFieldToDisplay: UITextField) {
        textFieldToDisplay.text = String(resultChange)
    }
}

// MARK: - Actions
extension ChangeViewController {

    @IBAction func changeValueOne(_ sender: UITextField) {
        selectedPickerText()
        changeValueText(labelMoneyToConvert, labelConvertedMoney, money!, sender)
    }

    @IBAction func changeValueTwo(_ sender: UITextField) {
        selectedPickerText()
        changeValueText(labelConvertedMoney, labelMoneyToConvert, money!, sender)
    }

    @IBAction func refreshButton(_ sender: UIBarButtonItem) {
        refresh()
    }
}

// MARK: - Keyboard
extension ChangeViewController: UITextFieldDelegate {
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        convertedCurrency.resignFirstResponder()
        currencyToConvert.resignFirstResponder()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - PickerView
extension ChangeViewController: UIPickerViewDataSource, UIPickerViewDelegate {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.nameList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.nameList[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pickerViewMoneyToConvert {
            selectedPickerText()
            changeValueText(labelMoneyToConvert, labelConvertedMoney, money!, currencyToConvert)
        } else {
            selectedPickerText()
            changeValueText(labelConvertedMoney, labelMoneyToConvert, money!, convertedCurrency)
        }
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
