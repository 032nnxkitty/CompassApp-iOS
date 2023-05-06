//
//  CompassViewController.swift
//  CompassApp
//
//  Created by Arseniy Zolotarev on 05.05.2023.
//

import UIKit

protocol CompassView: AnyObject {
    func updateHeadingLabel(with text: String)
    func updateDirectionLabel(with text: String)
    func rotateView(angle: Double)
}

class CompassViewController: UIViewController {
    var presenter: CompassPresenter!
    
    private var angleLabel: UILabel!
    private var directionLabel: UILabel!
    private var latitudeLabel: UILabel!
    private var longitudeLabel: UILabel!
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAppearance()
        configureAngleAndDirectionLabels()
    }
}

// MARK: - Private Methods
private extension CompassViewController {
    func configureAppearance() {
        view.backgroundColor = .systemBackground
    }
    
    func configureAngleAndDirectionLabels() {
        angleLabel = setupLabel(with: .title3)
        directionLabel = setupLabel(with: .title3)
        
        view.addSubview(angleLabel)
        view.addSubview(directionLabel)
        
        NSLayoutConstraint.activate([
            angleLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            angleLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            
            directionLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            directionLabel.topAnchor.constraint(equalTo: angleLabel.bottomAnchor),
        ])
    }
    
    func configureLatitudeAndLongitudeLabels() {
        latitudeLabel = setupLabel(with: .body)
        longitudeLabel = setupLabel(with: .body)
        
        view.addSubview(latitudeLabel)
        view.addSubview(longitudeLabel)
        
        NSLayoutConstraint.activate([
            latitudeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            latitudeLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            longitudeLabel.topAnchor.constraint(equalTo: latitudeLabel.bottomAnchor, constant: 4),
            longitudeLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
        ])
    }
    
    func setupLabel(with textStyle: UIFont.TextStyle) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: textStyle)
        label.textColor = .label
        return label
    }
}

// MARK: - CompassView Protocol
extension CompassViewController: CompassView {
    func updateHeadingLabel(with text: String) {
        angleLabel.text = text
    }
    
    func updateDirectionLabel(with text: String) {
        directionLabel.text = text
    }
    
    func rotateView(angle: Double) {
        // compassView.transform = CGAffineTransform(rotationAngle: -angle)
    }
}

