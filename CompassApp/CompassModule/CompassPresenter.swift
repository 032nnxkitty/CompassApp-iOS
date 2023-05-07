//
//  CompassPresenter.swift
//  CompassApp
//
//  Created by Arseniy Zolotarev on 05.05.2023.
//

import CoreLocation

protocol CompassPresenter {
    func shareButtonDidTap()
    func targetButtonDidTap()
    
    func addTarget(angle: String?)
}

class CompassPresenterImp: NSObject, CompassPresenter {
    private weak var view: CompassView?
    private var locationManager: CLLocationManager!
    
    private var heading:   Double
    private var direction: Direction
    private var latitude:  Double
    private var longitude: Double
    private var altitude:  Double
    
    private var targetAngle: Int?
    
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
    
    // MARK: - Public Methods
    func shareButtonDidTap() {
        print("Share")
    }
    
    func targetButtonDidTap() {
        if targetAngle == nil {
            // Add target
            let currentAngle = Int(locationManager.heading?.trueHeading ?? 0)
            view?.presentAddTargetAlert(with: "\(currentAngle)")
        } else {
            // Delete target
            targetAngle = nil
            view?.updateTargetState(label: "No target", button: "Add target")
        }
    }
    
    func addTarget(angle: String?) {
        guard let angle, let numAngle = Int(angle), (0...360).contains(numAngle) else { return }
        targetAngle = numAngle
        view?.updateTargetState(label: "Target: \(numAngle)°", button: "Delete target")
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
        
        let headingLabelText = String(format: "%d°", Int(heading))
        let rotatingAngle = -(heading * .pi / 180)
        
        view?.updateHeadingLabel(with: headingLabelText)
        view?.rotateCompass(angle: rotatingAngle)
        
        if direction != Direction(angle: heading) {
            direction = Direction(angle: heading)
            view?.updateDirectionLabel(with: direction.rawValue.capitalized)
        }
        
        if let targetAngle, (heading - 5...heading + 5).contains(Double(targetAngle)) {
            view?.setTargetBackground()
        } else {
            view?.setNormalBackground()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = manager.location else { return }
        
        let coordinate = location.coordinate
        
        guard abs(latitude - coordinate.latitude) > 0.0001, abs(longitude - coordinate.longitude) > 0.0001 else { return }
        
        latitude  = coordinate.latitude
        longitude = coordinate.longitude
        altitude  = location.altitude
        
        view?.updateCoordinates(lat: latitude.formatLatitude(),
                                lon: longitude.formatLongitude(),
                                alt: String(format: "%@ %.0fm", "Elev:", altitude))
        
        
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            guard let placemark = placemarks?.first, let locality = placemark.locality else { return }
            self.view?.updateLocality(locality)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
