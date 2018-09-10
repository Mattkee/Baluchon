//
//  TranslateViewController.swift
//  Baluchon
//
//  Created by Lei et Matthieu on 23/08/2018.
//  Copyright © 2018 Mattkee. All rights reserved.
//

import UIKit

class TranslateViewController: UIViewController {

    // MARK: - Properties
    let translateService = TranslateService()
    var language: Language?
    var languageList = [String]()
    var languageToTranslate = "fr"
    var languageTranslated = "en"

    override func viewDidLoad() {
        super.viewDidLoad()
        refresh()
        // Do any additional setup after loading the view.
    }

    // MARK: - Outlets
    @IBOutlet weak var textToTranslate: UITextView!
    @IBOutlet weak var textTranslated: UITextView!
    @IBOutlet weak var textToTranslatePicker: UIPickerView!
    @IBOutlet weak var textTranslatedPicker: UIPickerView!

    // MARK: - Action
    @IBAction func translateText(_ sender: UIButton) {
        selectedPickerText()
        translateService.getTranslate(textToTranslate: textToTranslate.text, languageToTranslate: languageToTranslate, languageTranslated: languageTranslated) { (error, translate) in
            guard error == nil else {
                guard let error = error else {
                    return
                }
                self.showAlert(title: "Echec Appel réseau", message: error)
                return
            }
            self.textTranslated.text = translate?.data.translations[0].translatedText
            self.textToTranslate.resignFirstResponder()
        }
    }
}

// MARK: - Methods
extension TranslateViewController {
    private func refresh() {
        translateService.getLanguage { (error, language) in
            guard error == nil else {
                self.showAlert(title: "Echec Appel réseau", message: error!)
                return
            }
            self.language = language
            guard let languages = language?.data.languages else {
                return
            }
            for language in languages {
                self.languageList.append(language.name)
            }
            self.languageList.sort()
            self.textToTranslatePicker.reloadComponent(0)
            self.textTranslatedPicker.reloadComponent(0)

            guard let french = self.languageList.index(of: "Français"), let english = self.languageList.index(of: "Anglais") else {
                return
            }
            self.textToTranslatePicker.selectRow(french, inComponent: 0, animated: false)
            self.textTranslatedPicker.selectRow(english, inComponent: 0, animated: false)
        }
    }

    private func selectedPickerText() {
        guard let languages = language?.data.languages else {
            return
        }
        for language in languages {
            if language.name == languageList[textToTranslatePicker.selectedRow(inComponent: 0)] {
                languageToTranslate = language.language
            } else if language.name == languageList[textTranslatedPicker.selectedRow(inComponent: 0)] {
                languageTranslated = language.language
            }
        }
    }
}

// MARK: - PickerView
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
