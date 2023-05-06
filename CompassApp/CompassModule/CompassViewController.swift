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
    func updateCoordinates(lat: String, lon: String, alt: String)
    func rotateView(angle: Double)
}

class CompassViewController: UIViewController {
    var presenter: CompassPresenter!
    
    // MARK: - UI Elements
    private var topStack:         UIStackView!
    private var angleLabel:       UILabel!
    private var directionLabel:   UILabel!
    private var cityCountryLabel: UILabel!
    private var latitudeLabel:    UILabel!
    private var longitudeLabel:   UILabel!
    private var altitudeLabel:    UILabel!
    private var speedLabel:       UILabel!
    
    private var compassImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        imageView.image = UIImage(named: "degrees")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .label
        return imageView
    }()
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAppearance()
        configureTopInfoLabels()
        configureCompassComponents()
        configureAngleAndDirectionLabels()
    }
}

// MARK: - Private Methods
private extension CompassViewController {
    func configureAppearance() {
        view.backgroundColor = .systemBackground
    }
    
    func configureTopInfoLabels() {
        topStack = createVStack()
        
        cityCountryLabel = setupLabel(with: .title2)
        latitudeLabel = setupLabel(with: .title2)
        longitudeLabel = setupLabel(with: .title2)
        altitudeLabel = setupLabel(with: .title2)
        
        view.addSubview(topStack)
        NSLayoutConstraint.activate([
            topStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            topStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            topStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
        
        topStack.addArrangedSubview(cityCountryLabel)
        topStack.addArrangedSubview(latitudeLabel)
        topStack.addArrangedSubview(longitudeLabel)
        topStack.addArrangedSubview(altitudeLabel)
    }
    
    func configureCompassComponents() {
        view.addSubview(compassImageView)
        
        let l = UIImageView(image: UIImage(systemName: "arrowtriangle.down.fill"))
        l.translatesAutoresizingMaskIntoConstraints = false
        l.tintColor = .systemRed
        view.addSubview(l)
        
        NSLayoutConstraint.activate([
            compassImageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -35),
            compassImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: -75),
            compassImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 75),
            compassImageView.heightAnchor.constraint(equalTo: compassImageView.widthAnchor),
            
            l.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            l.bottomAnchor.constraint(equalTo: compassImageView.topAnchor)
        ])
    }
    
    func configureAngleAndDirectionLabels() {
        angleLabel = setupLabel(with: .largeTitle)
        directionLabel = setupLabel(with: .largeTitle)
        
        let stack = createVStack()
        stack.alignment = .center
        
        stack.addArrangedSubview(angleLabel)
        stack.addArrangedSubview(directionLabel)
        
        view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            stack.topAnchor.constraint(equalTo: compassImageView.topAnchor, constant: 100),
        ])
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
    
    func updateCoordinates(lat: String, lon: String, alt: String) {
        cityCountryLabel.text = "Prague, Czech Republic"
        latitudeLabel.text = lat
        longitudeLabel.text = lon
        altitudeLabel.text = alt
    }
    
    func rotateView(angle: Double) {
        UIView.animate(withDuration: 0.2) {
            self.compassImageView.transform = CGAffineTransform(rotationAngle: angle)
        }
    }
}

