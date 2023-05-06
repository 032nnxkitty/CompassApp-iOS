//
//  CompassPresenter.swift
//  CompassApp
//
//  Created by Arseniy Zolotarev on 05.05.2023.
//

import CoreLocation

protocol CompassPresenter {
    
}

class CompassPresenterImp: NSObject, CompassPresenter {
    private weak var view: CompassView?
    private var locationManager: CLLocationManager!
    
    private var heading: Double
    private var direction: Direction
    private var latitude: Double
    private var longitude: Double
    private var altitude: Double
    
    // MARK: - Init
    init(view: CompassView) {
        self.view = view
        self.heading = 0
        self.direction = .unknown
        
        self.latitude = 0
        self.longitude = 0
        self.altitude = 0
        
        super.init()
        
        setup()
    }
}

// MARK: - Private Methods
private extension CompassPresenterImp {
    private func setup() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingHeading()
        locationManager.startUpdatingLocation()
    }
}

// MARK: - CLLocationManagerDelegate
extension CompassPresenterImp: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        heading = newHeading.trueHeading
        
        let headingLabelText = String(format: "%.0f°", heading)
        let rotatingAngle = -(heading * .pi / 180)
        
        view?.updateHeadingLabel(with: headingLabelText)
        view?.rotateView(angle: rotatingAngle)
        
        if direction != Direction(angle: heading) {
            direction = Direction(angle: heading)
            view?.updateDirectionLabel(with: direction.rawValue.capitalized)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = manager.location else { return }
        
        if abs(latitude - location.coordinate.latitude) > 0.0001, abs(longitude - location.coordinate.longitude) > 0.0001 {
            
            latitude = location.coordinate.latitude
            longitude = location.coordinate.longitude
            altitude = location.altitude
            
            let formattedLat = String(format: "%.6f", latitude)
            let formattedLon = String(format: "%.6f", longitude)
            let formattedAlt = String(format: "%.0f m", altitude)
            
            view?.updateCoordinates(lat: "Latitude: \(formattedLat)",
                                    lon: "Longitude: \(formattedLon)",
                                    alt: "Altitude: \(formattedAlt)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
