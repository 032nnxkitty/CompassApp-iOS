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
    
    // MARK: - Init
    init(view: CompassView) {
        self.view = view
        self.heading = 0
        self.direction = .unknown
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
        heading = newHeading.trueHeading
        
        view?.updateHeadingLabel(with: String(format: "%.0f°", heading))
        view?.rotateView(angle: -(heading * .pi / 180))
        
        if direction != Direction(angle: heading) {
            direction = Direction(angle: heading)
            view?.updateDirectionLabel(with: direction.rawValue.capitalized)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
