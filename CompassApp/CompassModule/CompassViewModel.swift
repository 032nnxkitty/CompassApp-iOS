//
//  CompassViewModel.swift
//  CompassApp
//
//  Created by Arseniy Zolotarev on 05.05.2023.
//

import CoreLocation

protocol CompassViewModel {
    var observableDirection: ObservableObject<String> { get }
    
    var observableHeading: ObservableObject<String> { get }
    
    var observableRotationAngle: ObservableObject<CGFloat> { get }
    
    var observableLatitude: ObservableObject<String> { get }
    
    var observableLongitude: ObservableObject<String> { get }
    
    var observableAltitude: ObservableObject<String> { get }
    
    var observableLocality: ObservableObject<String> { get }
}

final class CompassViewModelImpl: NSObject, CompassViewModel {
    private var locationManager = CLLocationManager()
    
    // MARK: - Properties
    var observableDirection: ObservableObject<String> = .init(value: "")
    private var direction: Direction = .none {
        didSet {
            observableDirection.value = direction.capitalizedString
        }
    }
    
    var observableHeading: ObservableObject<String> = .init(value: "")
    var observableRotationAngle: ObservableObject<CGFloat> = .init(value: 0)
    private var heading: Double = 0 {
        didSet {
            observableHeading.value = String(format: "%d°", Int(heading))
            observableRotationAngle.value = heading.rotationAngle()
        }
    }
    
    
    var observableLatitude: ObservableObject<String> = .init(value: "")
    private var latitude: Double = 0 {
        didSet {
            observableLatitude.value = latitude.formatCoordinate(style: .latitude)
        }
    }
    
    var observableLongitude: ObservableObject<String> = .init(value: "")
    private var longitude: Double = 0 {
        didSet {
            observableLongitude.value = longitude.formatCoordinate(style: .longitude)
        }
    }
    
    var observableAltitude: ObservableObject<String> = .init(value: "")
    private var altitude: Double = 0 {
        didSet {
            observableAltitude.value = altitude.formatAltitude()
        }
    }
    
    var observableLocality: ObservableObject<String> = .init(value: "")
    private var locality: String = "" {
        didSet {
            observableLocality.value = locality
        }
    }
    
    // MARK: - Init
    override init() {
        super.init()
        setupLocationManager()
    }
}

// MARK: - Private Methods
private extension CompassViewModelImpl {
    private func setupLocationManager() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
        locationManager.delegate = self
    }
}

// MARK: - CLLocationManagerDelegate
extension CompassViewModelImpl: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        heading = newHeading.trueHeading
        
        let newDirection = Direction(angle: heading)
        if direction != newDirection {
            direction = newDirection
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = manager.location else { return }
        let coordinate = location.coordinate
        
        let latitudeChange = abs(latitude - coordinate.latitude)
        let longitudeChange = abs(longitude - coordinate.longitude)
        
        if latitudeChange > 0.0001 {
            latitude = coordinate.latitude
        }
        
        if longitudeChange > 0.0001 {
            longitude = coordinate.longitude
        }
        
        if altitude != location.altitude {
            altitude = location.altitude
        }
        
        CLGeocoder().reverseGeocodeLocation(location) { [weak self] placemarks, error in
            guard let self else { return }
            guard let placemark = placemarks?.first, let locality = placemark.locality else { return }
            
            if self.locality != locality {
                self.locality = locality
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
