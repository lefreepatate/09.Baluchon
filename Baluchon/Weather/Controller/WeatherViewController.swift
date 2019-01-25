//
//  WeatherViewController.swift
//  Baluchon
//
//  Created by Carlos Garcia-Muskat on 24/01/2019.
//  Copyright © 2019 Carlos Garcia-Muskat. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {

   @IBOutlet weak var localTemp: UILabel!
   @IBOutlet weak var newYorkWeather: UILabel!
   
   override func viewDidLoad() {
      super.viewDidLoad()
      getWeather(with: "Lille", label: localTemp)
      getWeather(with: "New York", label: newYorkWeather)
   }
   
   private func getWeather(with city: String, label: UILabel!) {
      Weather.shared.getWeather(with: city) { (success, temp) in
         if success, let temp = temp {
            label.text = temp.capitalized
         } else {
            self.presentAlert(with: "The weather failed")
         }
      }
   }
   private func toggleActivityIndicator(shown: Bool) {
//      getRate.isHidden = shown
//      activityIndicator.isHidden = !shown
   }
   
   private func presentAlert(with message: String) {
      let alertVC = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
      alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
      present(alertVC, animated: true, completion: nil)
   }
}
