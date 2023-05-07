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
    private var bottomStack:      UIStackView!
    
    private var locationNameLabel: UILabel!
    private var angleLabel:        UILabel!
    private var directionLabel:    UILabel!
    private var latitudeLabel:     UILabel!
    private var longitudeLabel:    UILabel!
    private var altitudeLabel:     UILabel!
    private var speedLabel:        UILabel!
    
    private let toolBar: UIToolbar = {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 100, height: 34))
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        toolBar.tintColor = .systemRed
        return toolBar
    }()
    
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
        
        view.addSubview(toolBar)
        NSLayoutConstraint.activate([
            toolBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            toolBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            toolBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action,
                                          target: self,
                                          action: #selector(shareButtonDidTap))
        
//        let colorWell = UIColorWell()
//        colorWell.addTarget(self, action: #selector(shareButtonDidTap), for: .touchUpInside)
////        colorWell.supportsAlpha = false
////        colorWell.selectedColor = .systemRed
        
        toolBar.items = [//UIBarButtonItem(customView: colorWell),
                         UIBarButtonItem(systemItem: .flexibleSpace),
                         shareButton]
    }
    
    func configureTopInfoLabels() {
        topStack = createVStack()
        topStack.alignment = .center
         
        locationNameLabel = UILabel(textStyle: .largeTitle)
        locationNameLabel.text = "Praha"
        
        latitudeLabel  = UILabel(textStyle: .title2)
        longitudeLabel = UILabel(textStyle: .title2)
        altitudeLabel  = UILabel(textStyle: .title2)
        
        latitudeLabel.font = .monospacedSystemFont(ofSize: 17, weight: .regular)
        longitudeLabel.font = .monospacedSystemFont(ofSize: 17, weight: .regular)
        altitudeLabel.font = .monospacedSystemFont(ofSize: 17, weight: .regular)
        
        view.addSubview(topStack)
        NSLayoutConstraint.activate([
            topStack.bottomAnchor.constraint(equalTo: toolBar.topAnchor, constant: -16),
            topStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            topStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
        
        topStack.addArrangedSubview(locationNameLabel)
        topStack.addArrangedSubview(latitudeLabel)
        topStack.addArrangedSubview(longitudeLabel)
        topStack.addArrangedSubview(altitudeLabel)
    }
    
    func configureCompassComponents() {
        let angleArrow = UIImageView()
        angleArrow.image = UIImage(systemName: "arrowtriangle.down.fill")
        angleArrow.translatesAutoresizingMaskIntoConstraints = false
        angleArrow.tintColor = .systemRed
        view.addSubview(angleArrow)
        
        view.addSubview(compassImageView)
        NSLayoutConstraint.activate([
            compassImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 48),
            compassImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            compassImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            compassImageView.heightAnchor.constraint(equalTo: compassImageView.widthAnchor),
            
            angleArrow.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            angleArrow.bottomAnchor.constraint(equalTo: compassImageView.topAnchor)
        ])
    }
    
    func configureAngleAndDirectionLabels() {
        angleLabel = UILabel(textStyle: .largeTitle)
        directionLabel = UILabel(textStyle: .largeTitle)
        
        let stack = createVStack()
        stack.alignment = .center
        
        stack.addArrangedSubview(angleLabel)
        stack.addArrangedSubview(directionLabel)
        
        view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: compassImageView.centerYAnchor),
        ])
    }
    
    func createVStack() -> UIStackView {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        return stack
    }
}

@objc private extension CompassViewController {
    func shareButtonDidTap() {
        presenter.shareButtonDidTap()
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

