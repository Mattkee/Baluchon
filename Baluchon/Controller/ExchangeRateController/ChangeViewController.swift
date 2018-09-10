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
                guard let error = error else {
                    return
                }
                self.showAlert(title: Constant.titleAlert, message: error)
                return
            }
            self.money = money
            self.change = change
            guard let symbols = self.money?.symbols else {
                return
            }
            for (_, name) in symbols {
                self.nameList.append(name)
            }
            self.nameList.sort()
            self.pickerViewMoneyToConvert.reloadComponent(0)
            self.pickerViewConvertedMoney.reloadComponent(0)
            guard let euro = self.nameList.index(of: "Euro"), let usd = self.nameList.index(of: "United States Dollar") else {
                return
            }
            self.pickerViewMoneyToConvert.selectRow(euro, inComponent: 0, animated: false)
            self.pickerViewConvertedMoney.selectRow(usd, inComponent: 0, animated: false)
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
    private func changeValueText(_ moneyToConvertName: String, _ moneyConvertedName: String, _ sender: UITextField) {
        guard sender.hasText, let text = sender.text else {
            return
        }
        let result = changeService.changeMoney(moneyToConvertName, moneyConvertedName, text, change!, money!)
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
        changeValueText(labelMoneyToConvert, labelConvertedMoney, sender)
    }

    @IBAction func changeValueTwo(_ sender: UITextField) {
        selectedPickerText()
        changeValueText(labelConvertedMoney, labelMoneyToConvert, sender)
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
            changeValueText(labelMoneyToConvert, labelConvertedMoney, currencyToConvert)
        } else {
            selectedPickerText()
            changeValueText(labelConvertedMoney, labelMoneyToConvert, convertedCurrency)
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
