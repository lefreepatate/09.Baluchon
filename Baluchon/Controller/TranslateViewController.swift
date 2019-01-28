//
//  FirstViewController.swift
//  Baluchon
//
//  Created by Carlos Garcia-Muskat on 20/01/2019.
//  Copyright © 2019 Carlos Garcia-Muskat. All rights reserved.
//

import UIKit

class TranslateViewController: UIViewController, UITextFieldDelegate {
   @IBOutlet weak var textToTranslate: UITextField!
   @IBOutlet weak var textTranslated: UILabel!
   @IBOutlet weak var buttonTranslate: UIButton!
   @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
   @IBOutlet weak var language: UILabel!
   
   override func viewDidLoad() {
      super.viewDidLoad()
      buttonTranslate.layer.cornerRadius = buttonTranslate.frame.size.height/2
      view.setGradientBackground(colorOne: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), colorTwo: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1))
      self.textToTranslate.backgroundColor = UIColor.clear
   }
   
   @IBAction func changeLanguageButton(_ sender: UIButton) {
      changeLanguage()
   }
   @IBAction func tappedTranslateButton(_ sender: UIButton) {
      toggleActivityIndicator(shown: true)
      Translate.shared.getTranslate(with: textToTranslate.text!, language: textToTranslate.placeholder!) { (success, translated) in
         self.toggleActivityIndicator(shown: false)
         if success, let translated = translated {
            self.textTranslated.text = translated
         } else {
            self.presentAlert(with: "The translate failed")
         }
      }
   }
   
   private func changeLanguage() {
      textToTranslate.text = ""
      if textToTranslate.placeholder == "FR" {
         textToTranslate.placeholder = "EN"
         textTranslated.text = "FR"
         language.text = "TRANSLATION"
      } else if textToTranslate.placeholder == "EN" {
         textToTranslate.placeholder = "FR"
         textTranslated.text = "EN"
         language.text = "TRADUCTION"
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
