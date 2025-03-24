//
//  ViewController.swift
//  Clima
//
//  Created by MSOL on 23/03/2025.
//

import UIKit
import CoreLocation
protocol WeatherManagerDelegate: AnyObject {
    func didUpdateWeather(_ weather: WeatherModel)
    func didFailWithError(_ error: Error)
}
class WeatherViewController: UIViewController {
    //Outlets
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var tempratureLabel: UILabel!
    @IBOutlet weak var searchTF: UITextField!
    
    //Dependency
    var weatherManager = WeatherManager()
    var locationManager = CLLocationManager()
    //View LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        //Delegates
        searchTF.delegate = self
        weatherManager.delegate = self
        locationManager.delegate = self
        //request location permission
        locationManager.requestWhenInUseAuthorization()
        //request one time location
        locationManager.requestLocation() //trigers didUpdateLocations
        /*
         if you want updated location
         locationManager.startUpdatingLocation()
         */
    }

    //IBActions
    @IBAction func didTapSearch(_ sender: UIButton) {
        print("Did Tap Search")
        searchTF.endEditing(true) // To Dismiss the keyboard
    }
    
    @IBAction func didTapLocation(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    
}
//MARK: - UITextFieldDelegate
//to handle keyboard action use UITextFieldDelegate
//our view controller can be notified when the textfield ends editing
extension WeatherViewController: UITextFieldDelegate {
    // when the user press the return key in keyboard what should we do
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTF.endEditing(true) // To Dismiss the keyboard
        return true
    }
    //when the user stopped editing
    func textFieldDidEndEditing(_ textField: UITextField) {
        //make api call
        if let city = searchTF.text {
            weatherManager.fetchWeather(for: city)
        }
        searchTF.text = ""
    }
    //when the user tapped elsewhere should i allow him stop editing
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        //MARK: - make validation
        if textField.text != "" {
            return true
        } else {
            textField.text = "Type Something here..."
            return false
        }
    }
}

//MARK: - WeatherManagerDelegate
extension WeatherViewController: WeatherManagerDelegate {
    func didUpdateWeather(_ weather: WeatherModel) {
        DispatchQueue.main.async {[weak self] in
            guard let self = self else { return }
            self.cityLabel.text = weather.cityName
            self.tempratureLabel.text = weather.tempratureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
        }
    }
    //Handle Error with alert or something
    func didFailWithError(_ error: Error) {
        print("Error in vc \(error)")
    }
}
//MARK: - CLLocationManagerDelegate
extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            //if we have alreade requested location and we haven't changed our gps location, thern if there's no change then there is gonna be no update so this method is not gonna be called.
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print("Location error \(error)")
    }
}
