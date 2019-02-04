//
//  FirstViewController.swift
//  Baluchon
//
//  Created by Carlos Garcia-Muskat on 20/01/2019.
//  Copyright © 2019 Carlos Garcia-Muskat. All rights reserved.
//

import UIKit

class TranslateViewController: UIViewController {
   @IBOutlet weak var textToTranslate: UITextField!
   @IBOutlet weak var textTranslated: UILabel!
   @IBOutlet weak var buttonTranslate: UIButton!
   @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
   @IBOutlet weak var switchButton: UIButton!
   
   override func viewDidLoad() {
      super.viewDidLoad()
      getDesign()
      
   }
   @IBAction func changeLanguageButton(_ sender: UIButton) {
      changeLanguage()
   }
   @IBAction func tappedTranslateButton(_ sender: UIButton) {
      toggleActivityIndicator(shown: true)
      getTranslate()
      textToTranslate.resignFirstResponder()
   }
   private func getTranslate() {
      if textToTranslate.text == "" {
         self.presentAlert(with: "Rentrez un texte à traduire !")
         self.toggleActivityIndicator(shown: false)
      } else {
         Translate.shared.getTranslate(with: textToTranslate.text!, lang: textToTranslate.placeholder!)
         { (success, translated) in
            self.toggleActivityIndicator(shown: false)
            if success, let translated = translated {
               self.textTranslated.text = translated
            } else {
               self.presentAlert(with: "The translate failed")
            }
         }
      }
   }
   private func changeLanguage() {
      textToTranslate.text = ""
      if textToTranslate.placeholder == "FR" {
         textToTranslate.attributedPlaceholder = NSAttributedString(string: "EN", attributes: [NSAttributedString.Key.foregroundColor:#colorLiteral(red: 0, green: 0.5115655661, blue: 0.8635545373, alpha: 1)])
         textTranslated.text = "FR"
         buttonTranslate.setTitle("TRANSLATE", for: .normal)
      } else if textToTranslate.placeholder == "EN" {
         textToTranslate.attributedPlaceholder = NSAttributedString(string: "FR", attributes: [NSAttributedString.Key.foregroundColor:#colorLiteral(red: 0, green: 0.5115655661, blue: 0.8635545373, alpha: 1)])
         textTranslated.text = "EN"
         buttonTranslate.setTitle("TRADUIRE", for: .normal)
      }
   }
   private func toggleActivityIndicator(shown: Bool) {
      buttonTranslate.isHidden = shown
      activityIndicator.isHidden = !shown
   }
   private func presentAlert(with message: String) {
      let alertVC = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
      alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
      present(alertVC, animated: true, completion: nil)
   }
}
extension TranslateViewController {
   func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      textField.resignFirstResponder()
      return true
   }
   @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
      textToTranslate.resignFirstResponder()
   }
}
extension TranslateViewController {
   func getDesign() {
      //Switch button
      switchButton.layer.cornerRadius = switchButton.frame.size.height/2
      //  Button
      buttonTranslate.layer.cornerRadius = buttonTranslate.frame.size.height/2
      // Text to transalte  Label
      textToTranslate.attributedPlaceholder = NSAttributedString(string: "FR", attributes: [NSAttributedString.Key.foregroundColor:#colorLiteral(red: 0, green: 0.5115655661, blue: 0.8635545373, alpha: 1)])
      textToTranslate.layer.cornerRadius = textToTranslate.frame.size.height/4
      textToTranslate.clipsToBounds = true
      textToTranslate.layer.borderWidth = 2
      textToTranslate.layer.borderColor = #colorLiteral(red: 0, green: 0.2417031229, blue: 0.4070935249, alpha: 1)
      textToTranslate.backgroundColor = UIColor.clear
      // Text Translated Label
      textTranslated.layer.cornerRadius = textTranslated.frame.size.height/4
      textTranslated.layer.borderWidth = 2
      textTranslated.layer.borderColor = #colorLiteral(red: 0.7812640071, green: 0.1478679776, blue: 0.3184421062, alpha: 1)
      textTranslated.clipsToBounds = true
      view.setGradientBackground(colorOne: #colorLiteral(red: 0, green: 0.3037489057, blue: 0.5115984678, alpha: 1), colorTwo: #colorLiteral(red: 0.01578961685, green: 0.1178263798, blue: 0.1958183944, alpha: 1),
                                 xS: 0, yS: 0, xE: 1, yE: 1)
   }
}
