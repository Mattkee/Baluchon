//
//  FirstPickerViewController.swift
//  Baluchon
//
//  Created by Lei et Matthieu on 03/08/2018.
//  Copyright © 2018 Mattkee. All rights reserved.
//

import UIKit

class FirstPickerViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var nameList = [String]()
    var moneyOne = "Euro"
    var moneyTwo = "United States Dollar"
    
    @IBOutlet weak var firstPickerView: UIPickerView!
    @IBOutlet weak var secondPickerView: UIPickerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        firstPickerView.selectRow(nameList.index(of: "Euro")!, inComponent: 0, animated: false)
        secondPickerView.selectRow(nameList.index(of: "United States Dollar")!, inComponent: 0, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func selectMoney(_ sender: UIButton) {
        let chosenCurrencyOne = firstPickerView.selectedRow(inComponent: 0)
        moneyOne = nameList[chosenCurrencyOne]
        let chosenCurrencyTwo = secondPickerView.selectedRow(inComponent: 0)
        moneyTwo = nameList[chosenCurrencyTwo]
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
}

// MARK: - Navigation
extension FirstPickerViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "returnPickerSegue" {
            let successVC = segue.destination as! ChangeViewController
            successVC.labelMoneyToConvert = moneyOne// On passe la donnée via les propriétés
            successVC.labelConvertedMoney = moneyTwo
            print("c'est bon")
        }
    }
}
