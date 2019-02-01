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
   @IBOutlet weak var localDescr: UILabel!
   @IBOutlet weak var newYorkDescr: UILabel!
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      view.setGradientBackground(colorOne: #colorLiteral(red: 0.02950449102, green: 0.1226746961, blue: 0.1998404264, alpha: 1), colorTwo: #colorLiteral(red: 0.09552211314, green: 0.2562807798, blue: 0.3702481985, alpha: 1),
                                 xS: 0, yS: 0, xE: 1, yE: 1)
      getForecasWeather(with: "Lille", cityLabel: localDescr, day: localTemp,
                        minLabel: localMinTemp, maxLabel: localMaxTemp, days: localForecast)
      getForecasWeather(with: "New York", cityLabel: newYorkDescr, day: newYorkTemp,
                        minLabel: new_yorkMinTemp, maxLabel: new_yorkMaxTemp, days: nyForecast)
      
   }
   private func getForecasWeather(with city: String, cityLabel: UILabel!, day: UILabel!,
                                  minLabel: UILabel!, maxLabel: UILabel!, days: [UILabel]!) {
      Weather.shared.getForecastWeather(with: city) { (success, forecast) in
         if success, let forecast = forecast {
            cityLabel.text = "\(forecast[0].weather[0].description)"
            day.text = "\(Int(round(forecast[0].main.temp)))°C"
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
               let icon = "\(forecast[nmbr].weather[0].icon)"
               let dateformater = "\(self.dateFormat(date: forecast[nmbr].dt))"
               label.text = "\(dateformater.capitalized)\n\(Int(round(forecast[nmbr].main.temp)))°C\n"
               //               let stringIcon = self.iconAttachement(with: label, text: label.text!, iconImage: icon)
               print("\(icon)")
            }
         } else {
            self.presentAlert(with: "Forecast failed")
         }
      }
   }
   
   private func dateFormat(date: Int) -> String {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "EE d"
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
   func setGradientBackground(colorOne: UIColor, colorTwo: UIColor,
                              xS: Double, yS: Double, xE: Double, yE: Double){
      let gradientLayer = CAGradientLayer()
      gradientLayer.frame = bounds
      gradientLayer.locations = [0.0, 1.0]
      gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
      gradientLayer.startPoint = CGPoint(x: xS, y: yS)
      gradientLayer.endPoint = CGPoint(x: xE, y: yE)
      layer.insertSublayer(gradientLayer, at: 0)
   }
}
extension WeatherViewController {
   func iconAttachement(with label: UILabel, text: String, iconImage: String ) -> String {
      let string = NSMutableAttributedString(string: label.text!)
      let icon = NSTextAttachment()
      let stringWithIcon = NSAttributedString(attachment: icon)
      icon.image = UIImage(named: iconImage)
      string.append(stringWithIcon)
      label.attributedText = string
      return "\(string)"
   }
}
