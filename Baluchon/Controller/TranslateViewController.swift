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
   
   @IBAction func tappedTranslateButton(_ sender: UIButton) {
      toggleActivityIndicator(shown: true)
      Translate.shared.getTranslate(with: textToTranslate.text ?? "") { (success, translated) in
         self.toggleActivityIndicator(shown: false)
         if success, let translated = translated {
            self.update(translate: translated)
         } else {
            self.presentAlert(with: "The translate failed")
         }
      }
   }

   private func toggleActivityIndicator(shown: Bool) {
      buttonTranslate.isHidden = shown
      activityIndicator.isHidden = !shown
   }
   
   private func update(translate: String) {
      textTranslated.text = translate
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
