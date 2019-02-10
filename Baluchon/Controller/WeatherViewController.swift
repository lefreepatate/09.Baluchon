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
   
   override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
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
            self.tempBackgroundColor(with: weather[2] as! Int, label: temp)
            self.tempColor(with: weather[3] as! Int, label: tempMin)
            self.tempColor(with: weather[4] as! Int, label: tempMax)
            self.iconAttachement(with: descr, text: descr.text!, iconImage: weather[1] as! String)
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
               nmbr += 8
               let icon = "\(forecast[nmbr].weather[0].icon)"
               let temp = Int(round(forecast[nmbr].main.temp))
               let dateformater = "\(self.dateFormat(date: forecast[nmbr].dt, format: "EE d"))"
               self.tempColor(with: temp, label: label)
               label.text = "\(dateformater.capitalized)\n"
               label.text?.append("\(temp) °C\n")
               self.iconAttachement(with: label, text: label.text!, iconImage: icon)
               print("Ville: \(city)\n Date: \(dateformater)\n Heure: \(forecast[nmbr].dt_txt!)\n Icon: \(icon)")
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
   // Change color of font depending on the temperature blue = cold, yellow = temperate, orange = hot
   private func tempColor(with temp: Int, label: UILabel) {
      temp < 0 ? (label.backgroundColor = #colorLiteral(red: 0.2549601197, green: 0.5899073482, blue: 0.6969276667, alpha: 1)) : (label.backgroundColor = #colorLiteral(red: 0.827537477, green: 0.4212024808, blue: 0.02249474823, alpha: 1))
      label.layer.cornerRadius = label.frame.size.width/2
      label.clipsToBounds = true
      label.text = "\(temp)°C"
   }
   private func tempBackgroundColor(with temp: Int, label: UILabel) {
     temp < 0 ? (label.backgroundColor = #colorLiteral(red: 0.368086338, green: 0.8460097909, blue: 1, alpha: 1)) : (label.backgroundColor = #colorLiteral(red: 1, green: 0.5075404644, blue: 0, alpha: 1))
      label.layer.cornerRadius = label.frame.size.height/2
      label.clipsToBounds = true
      label.text = "\(temp)°C"
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
