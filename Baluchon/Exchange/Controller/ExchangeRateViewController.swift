//
//  SecondViewController.swift
//  Baluchon
//
//  Created by Carlos Garcia-Muskat on 20/01/2019.
//  Copyright © 2019 Carlos Garcia-Muskat. All rights reserved.
//

import UIKit

class ExchangeRateViewController: UIViewController {
   
   @IBOutlet weak var dollarsAmount: UITextField!
   @IBOutlet weak var eurosAmount: UILabel!
   @IBOutlet weak var getRate: UIButton!
   @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
   
   
   @IBAction func tappedRateButton(_ sender: Any) {
      toggleActivityIndicator(shown: true)
      getExchange()
   }
   
   private func getExchange() {
      Exchange.shared.getRate(with: dollarsAmount.text!) { (success, rate) in
         self.toggleActivityIndicator(shown: false)
         if success, let rate = rate {
            self.update(with: rate)
         } else {
            self.presentAlert(with: "The rate failed")
         }
      }
   }
   
   private func toggleActivityIndicator(shown: Bool) {
      getRate.isHidden = shown
      activityIndicator.isHidden = !shown
   }
   
   private func update(with euros: Float) {
      let formatted = String(format: "%.2f", euros)
      eurosAmount.text = formatted
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
      dollarsAmount.resignFirstResponder()
   }
}

