//
//  TranslateViewController.swift
//  Baluchon
//
//  Created by Lei et Matthieu on 23/08/2018.
//  Copyright © 2018 Mattkee. All rights reserved.
//

import UIKit

class TranslateViewController: UIViewController {

    var language: Language?
    var languageList = [String]()
    var languageToTranslate = "fr"
    var languageTranslated = "en"

    override func viewDidLoad() {
        super.viewDidLoad()
        refresh()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBOutlet weak var textToTranslate: UITextView!
    @IBOutlet weak var textTranslated: UITextView!

    @IBOutlet weak var textToTranslatePicker: UIPickerView!
    
    @IBOutlet weak var textTranslatedPicker: UIPickerView!

    @IBAction func translateText(_ sender: UIButton) {
        selectedPickerText()
        TranslateService.shared.getTranslate(textToTranslate: textToTranslate.text, languageToTranslate: languageToTranslate, languageTranslated: languageTranslated) { (success, translate) in
            
            if success {
                self.textTranslated.text = translate?.data.translations[0].translatedText
                
            } else {
                self.showAlert(title: "Echec Appel réseau", message: "rafraichir les données")
            }
        }
    }
    func refresh() {
        TranslateService.shared.getLanguage { (success, language) in
            
            if success {
                self.language = language
                for language in (language?.data.languages)! {
                    self.languageList.append(language.name)
                }
                self.languageList.sort()
                self.textToTranslatePicker.reloadComponent(0)
                self.textTranslatedPicker.reloadComponent(0)
                self.textToTranslatePicker.selectRow(self.languageList.index(of: "Français")!, inComponent: 0, animated: false)
                self.textTranslatedPicker.selectRow(self.languageList.index(of: "Anglais")!, inComponent: 0, animated: false)
            } else {
                self.showAlert(title: "Echec Appel réseau", message: "rafraichir les données")
            }
        }
    }
    private func selectedPickerText() {
        for language in (language?.data.languages)! {
            if language.name == languageList[textToTranslatePicker.selectedRow(inComponent: 0)] {
                languageToTranslate = language.language
            } else if language.name == languageList[textTranslatedPicker.selectedRow(inComponent: 0)] {
                languageTranslated = language.language
            }
        }
    }
}

//MARK: - PickerView
extension TranslateViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.languageList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.languageList[row]
    }
}

//MARK: - Keyboard
extension TranslateViewController: UITableViewDelegate {
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        textToTranslate.resignFirstResponder()
    }
    
    func textViewShouldReturn(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
}
// MARK: - Alert Management
extension TranslateViewController: DisplayAlert {
    func showAlert(title: String, message: String) {
        let alerteVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alerteVC.addAction(action)
        present(alerteVC, animated: true, completion: nil)
    }
}
