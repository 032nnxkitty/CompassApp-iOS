//
//  LocationInfoView.swift
//  CompassApp
//
//  Created by Arseniy Zolotarev on 24.06.2023.
//

import UIKit

final class LocationInfoView: UIStackView {
    // MARK: - UI Elements
    private let localityLabel  = UILabel(textStyle: .largeTitle)
    
    private let latitudeLabel  = UILabel(withMonoFontSize: 17)
    
    private let longitudeLabel = UILabel(withMonoFontSize: 17)
    
    private let altitudeLabel  = UILabel(withMonoFontSize: 17)
    
    // MARK: - Public Properties
    var locality: String = "" {
        didSet {
            localityLabel.text = locality
        }
    }
    
    var latitude: String = "" {
        didSet {
            latitudeLabel.text = latitude
        }
    }
    
    var longitude: String = "" {
        didSet {
            longitudeLabel.text = longitude
        }
    }
    
    var altitude: String = "" {
        didSet {
            altitudeLabel.text = altitude
        }
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configure()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Methods
private extension LocationInfoView {
    func configure() {
        alignment = .center
        axis = .vertical
        
        [localityLabel, latitudeLabel, longitudeLabel, altitudeLabel].forEach {
            addArrangedSubview($0)
        }
    }
}
