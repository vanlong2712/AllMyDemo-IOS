//
//  CityWeatherViewController.swift
//  AllMyDemo
//
//  Created by Long on 2/9/18.
//  Copyright © 2018 Long Dang. All rights reserved.
//

import UIKit

protocol ChangeCityDelegate {
    func userEnteredANewCityName(city: String)
}

class CityWeatherViewController: UIViewController {
    
    var delegate: ChangeCityDelegate?
    
    @IBOutlet weak var textField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func getWeatherCityName(_ sender: UIButton) {
        let cityName = textField.text
        if cityName != "" {
            delegate?.userEnteredANewCityName(city: cityName!)
        }
        dismiss(animated: true, completion: nil)
    }
    

    @IBAction func backButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    

}
