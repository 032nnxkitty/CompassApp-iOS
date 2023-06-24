//
//  CompassViewController.swift
//  CompassApp
//
//  Created by Arseniy Zolotarev on 05.05.2023.
//

import UIKit

final class CompassViewController: UIViewController {
    // MARK: - View Model
    let viewModel: CompassViewModel
    
    // MARK: - UI Elements
    private let directionInfoView = DirectionInfoView()
    
    private let locationInfoView = LocationInfoView()
    
    private let compassImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "degrees")
        imageView.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .label
        return imageView
    }()
    
    // MARK: - Init
    init(viewModel: CompassViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureAppearance()
        configureCompassComponents()
        configureDirectionInfoView()
        configureLocationInfoView()
        
        bind()
    }
}

// MARK: - Private Methods
private extension CompassViewController {
    func configureAppearance() {
        title = "Compass"
        view.backgroundColor = .systemBackground
    }
    
    func configureCompassComponents() {
        let angleArrow = UIImageView()
        angleArrow.image = UIImage(systemName: "arrowtriangle.down.fill")
        angleArrow.translatesAutoresizingMaskIntoConstraints = false
        angleArrow.tintColor = .systemRed
        view.addSubview(angleArrow)
        
        view.addSubview(compassImageView)
        NSLayoutConstraint.activate([
            compassImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            compassImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            compassImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            compassImageView.heightAnchor.constraint(equalTo: compassImageView.widthAnchor),
            
            angleArrow.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            angleArrow.bottomAnchor.constraint(equalTo: compassImageView.topAnchor)
        ])
    }
    
    func configureLocationInfoView() {
        locationInfoView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(locationInfoView)
        NSLayoutConstraint.activate([
            locationInfoView.topAnchor.constraint(equalTo: compassImageView.bottomAnchor, constant: 16),
            locationInfoView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            locationInfoView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    func configureDirectionInfoView() {
        directionInfoView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(directionInfoView)
        NSLayoutConstraint.activate([
            directionInfoView.centerXAnchor.constraint(equalTo: compassImageView.centerXAnchor),
            directionInfoView.centerYAnchor.constraint(equalTo: compassImageView.centerYAnchor),
        ])
    }
    
    func bind() {
        viewModel.observableHeading.bind { [weak self] newValue in
            guard let self else { return }
            self.directionInfoView.heading = newValue
        }
        
        viewModel.observableDirection.bind { [weak self] newValue in
            guard let self else { return }
            self.directionInfoView.direction = newValue
            self.generateImpactFeedback()
        }
        
        viewModel.observableRotationAngle.bind { [weak self] newValue in
            guard let self else { return }
            UIView.animate(withDuration: 0.2) {
                self.compassImageView.transform = .init(rotationAngle: newValue)
            }
        }
        
        viewModel.observableLatitude.bind { [weak self] newValue in
            guard let self else { return }
            self.locationInfoView.latitude = newValue
        }
        
        viewModel.observableLongitude.bind { [weak self] newValue in
            guard let self else { return }
            self.locationInfoView.longitude = newValue
        }
        
        viewModel.observableAltitude.bind { [weak self] newValue in
            guard let self else { return }
            self.locationInfoView.altitude = newValue
        }
        
        viewModel.observableLocality.bind { [weak self] newValue in
            guard let self else { return }
            self.locationInfoView.locality = newValue
        }
    }
}
