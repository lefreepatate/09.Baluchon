//
//  SecondViewController.swift
//  Baluchon
//
//  Created by Carlos Garcia-Muskat on 20/01/2019.
//  Copyright © 2019 Carlos Garcia-Muskat. All rights reserved.
//

import UIKit

class ExchangeRateViewController: UIViewController {
   // MARK: -- OUTLETS
   @IBOutlet weak var amountToConvert: UITextField!
   @IBOutlet weak var amountConverted: UILabel!
   @IBOutlet weak var getRate: UIButton!
   @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
   @IBOutlet weak var switchButton: UIButton!
   // MARK: -- OVERRIDE
   override func viewDidLoad() {
      super.viewDidLoad()
      getDesign()
   }
   // MARK: -- BUTTONS
   @IBAction func changeRateButton(_ sender: UIButton) {
      changeRate()
   }
   @IBAction func tappedRateButton(_ sender: Any) {
      toggleActivityIndicator(shown: true)
      getExchange(with: amountToConvert)
      amountToConvert.resignFirstResponder()
   }
   // MARK: -- API CALL
   private func getExchange(with textField: UITextField!) {
      if textField.text == "" {
         self.presentAlert(with: "Rentrez un montant à convertir")
         self.toggleActivityIndicator(shown: false)
      } else {
         Exchange.shared.getRate(with: textField.text!, symbol: amountToConvert.placeholder!) {
            (success, rate) in
            self.toggleActivityIndicator(shown: false)
            if success, let rate = rate {
               self.update(with: rate)
            } else {
               self.presentAlert(with: "The rate failed")
            }
         }
      }
   }
   // MARK: -- SWITCH SYMBOL EFFECTS
   private func changeRate() {
      amountToConvert.text = ""
      if amountToConvert.placeholder == "$" {
         amountToConvert.placeholder = "€"
         amountConverted.text = "$"
      } else if amountToConvert.placeholder == "€" {
         amountToConvert.placeholder = "$"
         amountConverted.text = "€"
      }
   }
   private func toggleActivityIndicator(shown: Bool) {
      getRate.isHidden = shown
      activityIndicator.isHidden = !shown
   }
   private func update(with euros: Float) {
      let formatted = String(format: "%.2f", euros)
      amountConverted.text = formatted
   }
   private func presentAlert(with message: String) {
      let alertVC = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
      alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
      present(alertVC, animated: true, completion: nil)
   }
}
// MARK: -- KEYBOARD DISMISS
extension ExchangeRateViewController {
   func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      textField.resignFirstResponder()
      return true
   }
   @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
      amountToConvert.resignFirstResponder()
   }
}
// MARK: -- DESIGN ATTRIBUTES
extension ExchangeRateViewController {
   private func getDesign(){
      //Switch button
      switchButton.layer.cornerRadius = switchButton.frame.size.height/2
      // GetRate Button
      getRate.layer.cornerRadius = getRate.frame.size.height/2
      // AmountToConvert  Label
       amountToConvert.layer.cornerRadius = amountToConvert.frame.size.height/8
      amountToConvert.clipsToBounds = true
      amountToConvert.layer.borderWidth = 2
      amountToConvert.layer.borderColor = #colorLiteral(red: 0.4837571979, green: 0.8734973669, blue: 1, alpha: 1)
      amountToConvert.backgroundColor = UIColor.clear
      // AmountConverted Label
      amountConverted.layer.cornerRadius = amountConverted.frame.size.height/8
      amountConverted.layer.borderWidth = 2
      amountConverted.layer.borderColor = #colorLiteral(red: 0.4901960784, green: 0.5725490196, blue: 1, alpha: 1)
      amountConverted.clipsToBounds = true
      // BackgroundColor
      view.setGradientBackground(colorOne: #colorLiteral(red: 0.4235294118, green: 0.7568627451, blue: 0.8823529412, alpha: 1), colorTwo: #colorLiteral(red: 0.4078431373, green: 0.4784313725, blue: 0.8509803922, alpha: 1),
                                 xS: 0, yS: 0, xE: 1, yE: 1)
      
   }
}

