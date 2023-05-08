//
//  CompassPresenter.swift
//  CompassApp
//
//  Created by Arseniy Zolotarev on 05.05.2023.
//

import CoreLocation

protocol CompassPresenter {
    func shareButtonDidTap()
    func didSelectTarget(_ index: Int)
    
    func getNumberOfTargets() -> Int
    func getTitleForTarget(at row: Int) -> String
}

final class CompassPresenterImp: NSObject, CompassPresenter {
    private weak var view: CompassView?
    private var locationManager: CLLocationManager!
    
    private var direction: Direction = .none
    private var heading:   Double = 0
    
    private var latitude:  Double = 0
    private var longitude: Double = 0
    private var altitude:  Double = 0
    
    private var target: Direction = .none
    
    // MARK: - Init
    init(view: CompassView) {
        self.view = view
        super.init()
        setup()
    }
    
    // MARK: - Public Methods
    func shareButtonDidTap() {
        view?.presentShareController(textToShare: "Latitude: \(latitude)\nLongitude: \(longitude)\nElevation: \(Int(altitude))m")
    }
    
    func didSelectTarget(_ index: Int) {
        target = Direction.allCases[index]
        
        var targetText: String?
        
        switch target {
        case .none:
            targetText = nil
        default:
            targetText = "Target: \(target.rawValue.capitalized)"
        }
        
        view?.updateTargetInfo(targetText: targetText)
    }
    
    func getNumberOfTargets() -> Int {
        return Direction.allCases.count
    }
    
    func getTitleForTarget(at row: Int) -> String {
        return Direction.allCases[row].rawValue.capitalized
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
        
        target == direction ? view?.setTargetBackground() : view?.setNormalBackground()
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
