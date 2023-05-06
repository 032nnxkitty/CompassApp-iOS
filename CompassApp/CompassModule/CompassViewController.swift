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
    func updateCoordinates(lat: String, lon: String)
    func rotateView(angle: Double)
}

class CompassViewController: UIViewController {
    var presenter: CompassPresenter!
    
    // MARK: - UI Elements
    private var angleLabel: UILabel!
    private var directionLabel: UILabel!
    private var cityCountryLabel: UILabel!
    private var latitudeLabel: UILabel!
    private var longitudeLabel: UILabel!
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAppearance()
        configureAngleAndDirectionLabels()
        configureTopLeftCornerInfo()
    }
}

// MARK: - Private Methods
private extension CompassViewController {
    func configureAppearance() {
        view.backgroundColor = .systemBackground
    }
    
    func configureAngleAndDirectionLabels() {
        angleLabel = setupLabel(with: .largeTitle)
        directionLabel = setupLabel(with: .largeTitle)
        
        view.addSubview(angleLabel)
        view.addSubview(directionLabel)
        
        NSLayoutConstraint.activate([
            angleLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            angleLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            
            directionLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            directionLabel.topAnchor.constraint(equalTo: angleLabel.bottomAnchor),
        ])
    }
    
    func configureTopLeftCornerInfo() {
        cityCountryLabel = setupLabel(with: .headline)
        cityCountryLabel.text = "Prague, Czech Republic"
        latitudeLabel = setupLabel(with: .body)
        longitudeLabel = setupLabel(with: .body)
        
        let stack = createVStack()
        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            stack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        stack.addArrangedSubview(cityCountryLabel)
        stack.addArrangedSubview(latitudeLabel)
        stack.addArrangedSubview(longitudeLabel)
    }
    
    func setupLabel(with textStyle: UIFont.TextStyle) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: textStyle)
        label.textColor = .label
        return label
    }
    
    func createVStack() -> UIStackView {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        return stack
    }
}

// MARK: - CompassView Protocol
extension CompassViewController: CompassView {
    func updateHeadingLabel(with text: String) {
        angleLabel.text = text
    }
    
    func updateDirectionLabel(with text: String) {
        directionLabel.text = text
        
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
    func updateCoordinates(lat: String, lon: String) {
        latitudeLabel.text = lat
        longitudeLabel.text = lon
    }
    
    func rotateView(angle: Double) {
        // compassView.transform = CGAffineTransform(rotationAngle: -angle)
    }
}

