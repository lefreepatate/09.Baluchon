//
//  SecondViewController.swift
//  Baluchon
//
//  Created by Carlos Garcia-Muskat on 20/01/2019.
//  Copyright © 2019 Carlos Garcia-Muskat. All rights reserved.
//

import UIKit

class ExchangeRateViewController: UIViewController {
   
   @IBOutlet weak var amountToConvert: UITextField!
   @IBOutlet weak var amountConverted: UILabel!
   @IBOutlet weak var currency: UILabel!
   @IBOutlet weak var getRate: UIButton!
   @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
   
   
   override func viewDidLoad() {
      super.viewDidLoad()
      getRate.layer.cornerRadius = getRate.frame.size.height/2
      view.setGradientBackground(colorOne: #colorLiteral(red: 0, green: 0.4986943603, blue: 0.832082212, alpha: 1), colorTwo: #colorLiteral(red: 0.01331167482, green: 0.2907650173, blue: 0.4864638448, alpha: 1))
      self.amountToConvert.backgroundColor = UIColor.clear
      
   }
   
   @IBAction func changeRateButton(_ sender: UIButton) {
      changeRate()
   }
   @IBAction func tappedRateButton(_ sender: Any) {
      toggleActivityIndicator(shown: true)
      getExchange(with: amountToConvert)
   }
   
   private func getExchange(with textField: UITextField!) {
      Exchange.shared.getRate(with: textField.text!, symbol: amountToConvert.placeholder!) { (success, rate) in
         self.toggleActivityIndicator(shown: false)
         if success, let rate = rate {
            self.update(with: rate)
         } else {
            self.presentAlert(with: "The rate failed")
         }
      }
   }
   
   private func changeRate() {
      amountToConvert.text = ""
      if amountToConvert.placeholder == "$" {
         amountToConvert.placeholder = "€"
         amountConverted.text = "$"
         currency.text = "Dollars"
      } else if amountToConvert.placeholder == "€" {
         amountToConvert.placeholder = "$"
         amountConverted.text = "€"
         currency.text = "Euros"
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

extension ExchangeRateViewController {
   func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      textField.resignFirstResponder()
      return true
   }
   
   @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
      amountToConvert.resignFirstResponder()
   }
}

