//
//  WeatherViewController.swift
//  Baluchon
//
//  Created by Carlos Garcia-Muskat on 24/01/2019.
//  Copyright © 2019 Carlos Garcia-Muskat. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {
   // NY
   @IBOutlet weak var iconLabel: UILabel!
   @IBOutlet weak var newYorkTemp: UILabel!
   @IBOutlet weak var newYorkDescr: UILabel!
   @IBOutlet weak var new_yorkMinTemp: UILabel!
   @IBOutlet weak var new_yorkMaxTemp: UILabel!
   @IBOutlet var nyForecast: [UILabel]!
   // Local
   @IBOutlet weak var iconLocalLabel: UILabel!
   @IBOutlet weak var localTemp: UILabel!
   @IBOutlet weak var localMinTemp: UILabel!
   @IBOutlet weak var localMaxTemp: UILabel!
   @IBOutlet weak var localDescr: UILabel!
   @IBOutlet var localForecast: [UILabel]!
   
   override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      getWeather(with: "Lille", descr: localDescr, icon: iconLocalLabel, temp: localTemp,
                 tempMin: localMinTemp, tempMax: localMaxTemp, days: localForecast)
      getWeather(with: "New York", descr: newYorkDescr, icon: iconLabel, temp: newYorkTemp,
                 tempMin: new_yorkMinTemp, tempMax: new_yorkMaxTemp, days: nyForecast)
   }
   override func viewDidLoad() {
      super.viewDidLoad()
      view.setGradientBackground(colorOne: #colorLiteral(red: 0.02950449102, green: 0.1226746961, blue: 0.1998404264, alpha: 1), colorTwo: #colorLiteral(red: 0.09552211314, green: 0.2562807798, blue: 0.3702481985, alpha: 1),
                                 xS: 0, yS: 0, xE: 1, yE: 1)
   }
   private func getWeather(with city: String, descr: UILabel!, icon: UILabel!, temp: UILabel!,
                           tempMin: UILabel!, tempMax: UILabel!, days: [UILabel]!) {
      Weather.shared.getWeather(with: city, type: "weather") { (success, weather) in
         if success, let weather = weather {
            descr.text = "\(weather[0])"
            icon.text = ""
            self.tempBackgroundColor(with: weather[2] as! Int, label: temp,
                                     icon: weather[1] as! String)
            self.tempColor(with: weather[3] as! Int, label: tempMin)
            self.tempColor(with: weather[4] as! Int, label: tempMax)
            self.iconAttachement(with: icon, text: icon.text!, iconImage: weather[1] as! String)
            self.get4daysWeather(with: city, days: days)
         } else {
            self.presentAlert(with: "The weather failed")
         }
      }
   }
   private func get4daysWeather(with city: String, days: [UILabel]!) {
      Weather.shared.getWeather(with: city, type: "forecast") { (success, forecast) in
         if success, let forecast = forecast as! [List]? {
            var nmbr = 0
            for label in days {
               label.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2)
               nmbr += 8
               let icon = "\(forecast[nmbr].weather[0].icon)"
               let temp = Int(round(forecast[nmbr].main.temp))
               let dateformater = "\(self.dateFormat(date: forecast[nmbr].dt, format: "EE d"))"
               label.text = "\(dateformater.capitalized)\n\(temp) °C\n"
               self.iconAttachement(with: label, text: label.text!, iconImage: icon)
            }
         } else {
            self.presentAlert(with: "Forecast failed")
         }
      }
   }
   // Change date format to 'Day. Nmbr'
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
// Change color of font depending on the temperature blue = cold, yellow = temperate, orange = hot
extension WeatherViewController {
   func tempColor(with temp: Int, label: UILabel) {
      if temp <= 10 { label.textColor = #colorLiteral(red: 0.368086338, green: 0.8460097909, blue: 1, alpha: 1) }
      else if 11...25 ~= temp { label.textColor = #colorLiteral(red: 1, green: 0.8, blue: 0, alpha: 1) }
      else { label.textColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1) }
      label.text = "\(temp)°C"
   }
   func tempBackgroundColor(with temp: Int, label: UILabel, icon: String) {
      dayNightBackground(with: temp, label: label, dayNight: icon)
      label.layer.cornerRadius = label.frame.size.height/2
      label.clipsToBounds = true
      label.text = "\(temp)°C"
   }
   func dayNightBackground(with temp: Int, label: UILabel!, dayNight: String) {
      borderTempColor(with: temp, label: label)
      if dayNight.contains("d") {
         if temp <= 10 { label.backgroundColor = #colorLiteral(red: 0.368086338, green: 0.8460097909, blue: 1, alpha: 0.8) }
         else if 11...25 ~= temp { label.backgroundColor = #colorLiteral(red: 1, green: 0.8, blue: 0, alpha: 0.8) }
         else { label.backgroundColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 0.8) }
      } else if dayNight.contains("n") {
         label.backgroundColor = #colorLiteral(red: 0.007809357594, green: 0.09466643745, blue: 0.1573223039, alpha: 1)
         if temp <= 10 {label.textColor = #colorLiteral(red: 0.368086338, green: 0.8460097909, blue: 1, alpha: 1)  }
         else if 11...25 ~= temp { label.textColor = #colorLiteral(red: 1, green: 0.8, blue: 0, alpha: 1) }
         else { label.textColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1) }
      }
   }
   func borderTempColor(with temp: Int, label: UILabel) {
      label.layer.borderWidth = 2
      if temp <= 10 { label.layer.borderColor = #colorLiteral(red: 0.368086338, green: 0.8460097909, blue: 1, alpha: 1) }
      else if 11...25 ~= temp { label.layer.borderColor = #colorLiteral(red: 1, green: 0.8, blue: 0, alpha: 1) }
      else { label.layer.borderColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1) }
      label.text = "\(temp)°C"
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
