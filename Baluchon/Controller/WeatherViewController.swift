//
//  WeatherViewController.swift
//  Baluchon
//
//  Created by Carlos Garcia-Muskat on 24/01/2019.
//  Copyright © 2019 Carlos Garcia-Muskat. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {
   // Local
   @IBOutlet weak var localTemp: UILabel!
   @IBOutlet weak var localMinTemp: UILabel!
   @IBOutlet weak var localMaxTemp: UILabel!
   @IBOutlet weak var localDescr: UILabel!
   @IBOutlet var localForecast: [UILabel]!
   // NY
   @IBOutlet weak var newYorkTemp: UILabel!
   @IBOutlet weak var newYorkDescr: UILabel!
   @IBOutlet weak var new_yorkMinTemp: UILabel!
   @IBOutlet weak var new_yorkMaxTemp: UILabel!
   @IBOutlet var nyForecast: [UILabel]!
   
   override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
      getWeather(with: "Lille", descr: localDescr, temp: localTemp,
                 tempMin: localMinTemp, tempMax: localMaxTemp, days: localForecast)
      getWeather(with: "New York", descr: newYorkDescr, temp: newYorkTemp,
                 tempMin: new_yorkMinTemp, tempMax: new_yorkMaxTemp, days: nyForecast)
   }
   override func viewDidLoad() {
      super.viewDidLoad()
      view.setGradientBackground(colorOne: #colorLiteral(red: 0.02950449102, green: 0.1226746961, blue: 0.1998404264, alpha: 1), colorTwo: #colorLiteral(red: 0.09552211314, green: 0.2562807798, blue: 0.3702481985, alpha: 1),
                                 xS: 0, yS: 0, xE: 1, yE: 1)
   }
   private func getWeather(with city: String, descr: UILabel!, temp: UILabel!, tempMin: UILabel!, tempMax: UILabel!, days: [UILabel]!) {
      Weather.shared.getWeather(with: city, type: "weather") { (success, weather) in
         if success, let weather = weather {
            descr.text = "\(weather[0])\n"
            temp.text = "\(weather[2])°C"
            self.iconAttachement(with: descr, text: descr.text!, iconImage: weather[1] as! String)
            tempMin.text = "\(weather[3])°C"
            tempMax.text = "\(weather[4])°C"
            self.get4daysWeather(with: city, days: days)
         } else {
            self.presentAlert(with: "The weather failed")
         }
      }
   }
   private func get4daysWeather(with city: String, days: [UILabel]!) {
      Weather.shared.getWeather(with: city, type: "forecast") { (success, forecast) in
         if success, let forecast = forecast as! [List]? {
            var nmbr = 6
            for label in days {
               let icon = "\(forecast[nmbr].weather[0].icon)"
               let dateformater = "\(self.dateFormat(date: forecast[nmbr].dt, format: "EE d"))"
               label.text = "\(dateformater.capitalized)\n\(Int(round(forecast[nmbr].main.temp)))°C\n"
               self.iconAttachement(with: label, text: label.text!, iconImage: icon)
               print("Ville: \(city)\n Date: \(dateformater)\n Heure: \(forecast[nmbr].dt_txt!)")
               nmbr += 8
            }
         } else {
            self.presentAlert(with: "Forecast failed")
         }
      }
   }
   private func dateFormat(date: Int, format: String) -> String {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = format
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
   func iconAttachement(with label: UILabel, text: String, iconImage: String ) {
      let string = NSMutableAttributedString(string: label.text!)
      let icon = NSTextAttachment()
      icon.image = UIImage(named: iconImage)
      icon.bounds = CGRect(x: 0, y: 0, width:50, height:50)
      let stringWithIcon = NSAttributedString(attachment: icon)
      string.append(stringWithIcon)
      label.attributedText = string
   }
}
