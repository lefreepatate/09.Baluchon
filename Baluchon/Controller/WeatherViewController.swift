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
   @IBOutlet weak var localMinTemp: UILabel!
   @IBOutlet weak var localMaxTemp: UILabel!
   @IBOutlet weak var newYorkTemp: UILabel!
   @IBOutlet weak var new_yorkMinTemp: UILabel!
   @IBOutlet weak var new_yorkMaxTemp: UILabel!
   @IBOutlet var localForecast: [UILabel]!
   @IBOutlet var nyForecast: [UILabel]!
   @IBOutlet weak var localText: UITextView!
   
   let sunImage = UIImage(named: "01d")!
   override func viewDidLoad() {
      super.viewDidLoad()
      view.setGradientBackground(colorOne: #colorLiteral(red: 0.02950449102, green: 0.1226746961, blue: 0.1998404264, alpha: 1), colorTwo: #colorLiteral(red: 0.09552211314, green: 0.2562807798, blue: 0.3702481985, alpha: 1))
      getForecasWeather(with: "Lille", cityLabel: localText, day: localTemp,
                        minLabel: localMinTemp, maxLabel: localMaxTemp, days: localForecast)
      getForecasWeather(with: "New York", cityLabel: localText, day: newYorkTemp,
                        minLabel: new_yorkMinTemp, maxLabel: new_yorkMaxTemp, days: nyForecast)
      
   }
   
   private func getForecasWeather(with city: String, cityLabel: UITextView!, day: UILabel!,
                                  minLabel: UILabel!, maxLabel: UILabel!, days: [UILabel]!) {
      Weather.shared.getForecastWeather(with: city) { (success, forecast) in
         if success, let forecast = forecast {
            cityLabel.text += "\n\(forecast[0].weather[0].description)"
            day.text = "\(Int(round(forecast[0].main.temp)))°C\n"
            minLabel.text = "\(Int(round(forecast[0].main.temp_min)))°C"
            maxLabel.text = "\(Int(round(forecast[0].main.temp_max)))°C"
            self.get4daysWeather(with: city, days: days)
         } else {
            self.presentAlert(with: "Forecast failed")
         }
      }
   }
   
   private func get4daysWeather(with city: String, days: [UILabel]!) {
      Weather.shared.getForecastWeather(with: city) { (success, forecast) in
         if success, let forecast = forecast {
            var nmbr = 0
            for label in days {
               nmbr += 8
               let dateformater = "\(self.dateFormat(date: forecast[nmbr].dt))"
               label.text =  "\(dateformater.capitalized)\n"
                  + "\(Int(round(forecast[nmbr].main.temp)))°C\n"
                  + "\(forecast[nmbr].weather[0].description)"
            }
         } else {
            self.presentAlert(with: "Forecast failed")
         }
      }
   }
   
   private func dateFormat(date: Int) -> String {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "EEEE d"
      dateFormatter.locale = Locale(identifier: "fr")
      let date = Date(timeIntervalSince1970: TimeInterval(date))
      return "\(dateFormatter.string(from: date))"
   }
   
   private func presentAlert(with message: String) {
      let alertVC = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
      alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
      present(alertVC, animated: true, completion: nil)
   }
}
extension UIView {
   func setGradientBackground(colorOne: UIColor, colorTwo: UIColor){
      let gradientLayer = CAGradientLayer()
      gradientLayer.frame = bounds
      gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
      gradientLayer.startPoint = CGPoint(x: 0, y: 0)
      gradientLayer.endPoint = CGPoint(x: 0, y: 1)
      layer.insertSublayer(gradientLayer, at: 0)
   }
}
