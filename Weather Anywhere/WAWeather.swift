//
//  WAWeather.swift
//  Weather Anywhere
//
//  Created by Rick Wierenga on 12/02/2019.
//  Copyright © 2019 Rick Wierenga. All rights reserved.
//

import MapKit

class WAWeather {
    var temperature: Double?
    var coordinate: CLLocationCoordinate2D
    var fetchedWeatherDone: (WAWeather) -> Void
    
    private let API_KEY = "7ec0b4646e81e1e5d53e4213c6644b06"
    private let BASE_URL = "https://api.openweathermap.org/data/2.5/weather"
    
    init(coordinate: CLLocationCoordinate2D, fetchedWeatherDone: @escaping (WAWeather) -> Void) {
        self.coordinate = coordinate
        self.fetchedWeatherDone = fetchedWeatherDone
        self.fetchWeather()
    }
    
    private func fetchWeather() {
        if let url = URL(string: BASE_URL + "?lat=\(self.coordinate.latitude)&lon=\(self.coordinate.longitude)&APPID=\(API_KEY)&units=metric") {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard error == nil else {
                    print(error!)
                    return
                }

                if let data = data, let json = try? JSON(data: data) {
                    DispatchQueue.main.async {
                        self.temperature = json["main"]["temp"].doubleValue
                        self.fetchedWeatherDone(self)
                    }
                }
            }
            task.resume()
        }
    }
}
