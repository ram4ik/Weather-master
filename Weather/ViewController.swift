//
//  ViewController.swift
//  Weather
//
//  Created by ramill on 04/08/2018.
//  Copyright © 2018 RI. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var temp: UILabel!
    @IBOutlet weak var max_temp: UILabel!
    @IBOutlet weak var min_temp: UILabel!
    @IBOutlet weak var description_label: UILabel!
    @IBOutlet weak var date_time_label: UILabel!
    @IBOutlet weak var main_weather_label: UILabel!

    
    @IBOutlet weak var image: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        self.weatherTextField.delegate = self

        temp.isHidden = true
        max_temp.isHidden = true
        min_temp.isHidden = true
        description_label.isHidden = true
        date_time_label.isHidden = true
        main_weather_label.isHidden = true

        pressure.isHidden = true
        humidity.isHidden = true

        temp.textColor = UIColor.white
        max_temp.textColor = UIColor.white
        min_temp.textColor = UIColor.white
        description_label.textColor = UIColor.white
        date_time_label.textColor = UIColor.white
        main_weather_label.textColor = UIColor.white
        pressure.textColor = UIColor.white
        humidity.textColor = UIColor.white
        getWeatherInfoText.setTitleColor(UIColor.white, for: .normal)


    }
    @IBOutlet weak var pressure: UILabel!
    @IBOutlet weak var humidity: UILabel!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBOutlet weak var weatherTextField: UITextField!

    @IBOutlet weak var getWeatherInfoText: UIButton!
    @IBAction func getWeatherInfoBtn(_ sender: Any) {

        //var city: String? = "tallinn"
        var city = weatherTextField.text!.isEmpty ? "tallinn" : weatherTextField.text
        print(city!)
        city = city?.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
        print(city!)

        self.image.image = UIImage(named: "")

        var humidity_value = ""
        var pressure_value = ""
        var temperature_value = ""
        var max_temperature_value = ""
        var min_temperature_value = ""
        var description_label_value = ""
        var date_time_label_value = ""
        var main_weather_label_value = ""

        let url = "https://api.openweathermap.org/data/2.5/weather?q=\(city!)&appid=1071d2f563da5a42521a847096a4dabd"
        print("URL is: \(url)")
        Alamofire.request(url).responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result

            if let json = response.result.value {
                print("JSON: \(json)") // serialized json response

            }

            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)") // original server data as UTF8 string
            }

            if let dict = response.result.value as? NSDictionary {
                print("DICTIONARY: \(dict)")
                if let dateTime = dict["dt"] as? Int {
                    print("Day time: \(dateTime)")
                    date_time_label_value = String(dateTime)

                    if let main = dict["main"] as? NSDictionary {
                        print("Main: \(main)")

                        if let humidity = main["humidity"] as? Int {
                            print("Humidity: \(humidity)")
                            humidity_value = String(humidity)
                        }
                        if let pressure = main["pressure"] as? Int {
                            print("Pressure: \(pressure)")
                            pressure_value = String(pressure)
                        }
                        if let temp_max = main["temp_max"] as Any? {
                            print("temp_max: \(temp_max)")
                            max_temperature_value = "\(temp_max)"
                        }
                        if let temp_min = main["temp_min"] as Any? {
                            print("temp_min: \(temp_min)")
                            min_temperature_value = "\(temp_min)"
                        }
                        if let temp = main["temp"] as Any? {
                            print("temp: \(temp)")
                            temperature_value = "\(temp)"
                        }
                    }

                    if let weatherArray = dict["weather"] as? [[String:Any]],
                        let weather = weatherArray.first {
                        let description = weather["description"] as! String
                        print(description)
                        description_label_value = description

                        let main_weather = weather["main"] as! String
                        main_weather_label_value = main_weather
                    }
                }
            }
            
            self.humidity.text = "Humidity: \(humidity_value)%"
            self.pressure.text = "Pressure: \(pressure_value)hPA"
            self.temp.text = "Temperature: \(Float(((temperature_value as NSString).doubleValue) - 273.15))ºC"
            self.max_temp.text = "Max temperature: \(Float(((max_temperature_value as NSString).doubleValue) - 273.15))ºC"
            self.min_temp.text = "Min temperature: \(Float(((min_temperature_value as NSString).doubleValue) - 273.15))ºC"
            self.date_time_label.text = "Last updated: \(self.getDateFromTimeStamp(timeStamp: (date_time_label_value as NSString).doubleValue))"
            self.description_label.text = "Description: \(description_label_value)"
            self.main_weather_label.text = "\(main_weather_label_value)"
            let forEmoji = "\(main_weather_label_value)"
            print("FOREMOJI: \(forEmoji)")
            self.getEmoji(status: "\(main_weather_label_value)")
            print("\(main_weather_label_value)")
        }

        temp.isHidden = false
        max_temp.isHidden = false
        min_temp.isHidden = false
        description_label.isHidden = false
        date_time_label.isHidden = false
        main_weather_label.isHidden = false
        
        pressure.isHidden = false
        humidity.isHidden = false

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        weatherTextField.resignFirstResponder()
        return (true)
    }

    func getDateFromTimeStamp(timeStamp : Double) -> String {

        let date = NSDate(timeIntervalSince1970: timeStamp)

        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "dd MMM YY, hh:mm a"
        // UnComment below to get only time
        //  dayTimePeriodFormatter.dateFormat = "hh:mm a"

        let dateString = dayTimePeriodFormatter.string(from: date as Date)
        return dateString
    }

    func getEmoji(status: String) {

        if status == "Clear" {
            self.image.image = UIImage(named: "if_sun_3233848")
        }
        if status == "Rain" {
            self.image.image = UIImage(named: "if_rain_3233856")
        }
        if status == "Lightning" {
            self.image.image = UIImage(named: "if_lightning_3233854")
        }
        if status == "Snow" {
            self.image.image = UIImage(named: "if_snow_3233849")
        }
        if status == "Large cloud" {
            self.image.image = UIImage(named: "if_cloudy_3233857")
        }
        if status == "Small cloud" {
            self.image.image = UIImage(named: "if_cloud_3233855")
        }
        if status == "Clouds" {
            self.image.image = UIImage(named: "if_cloudy_3233857")
        }
        if status == "Fog" {
            self.image.image = UIImage(named: "if_cloudy_3233857")
        }
//        else {
//            self.image.image = UIImage(named: "if_sunny_3233850")
//        }
    }


}

