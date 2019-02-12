//
//  ViewController.swift
//  Weather Anywhere
//
//  Created by Rick Wierenga on 12/02/2019.
//  Copyright © 2019 Rick Wierenga. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var map: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add a gesture recognizer to the map.
        let lpgr = UILongPressGestureRecognizer()
        lpgr.minimumPressDuration = 0.6
        lpgr.addTarget(self, action: #selector(tap))
        self.map.addGestureRecognizer(lpgr)
    }
    
    @objc private func tap(_ lpgr: UILongPressGestureRecognizer) {
        let location = map.convert(lpgr.location(in: map), toCoordinateFrom: map)
        let _ = WAWeather(coordinate: location) { (weather) in
            self.addAnnotation(for: weather)
        }
    }
    
    private func addAnnotation(for weather: WAWeather) {
        guard let temp = weather.temperature else { return }
        let annotation = MKPointAnnotation()
        annotation.coordinate = weather.coordinate
        annotation.title = "\(temp)°C"
        self.map.addAnnotation(annotation)
    }
}
