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
    
    init(view: CompassView) {
        self.view = view
        
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
    }
}

// MARK: - CLLocationManagerDelegate
extension CompassPresenterImp: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        let angle = newHeading.trueHeading.rounded(.towardZero)
        view?.updateHeadingLabel(with: "\(angle)°")
    }
}
