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
    func updateLocality(_ locality: String)
    func updateTargetState(label: String, button: String)
    
    func setNormalBackground()
    func setTargetBackground()
    
    func rotateCompass(angle: Double)
    
    func presentAddTargetAlert(with text: String)
}

class CompassViewController: UIViewController {
    var presenter: CompassPresenter!
    
    // MARK: - UI Elements
    private var coordinatesContainerStack: UIStackView!
    private var directionContainerStack:   UIStackView!
    
    private var localityLabel:  UILabel!
    private var latitudeLabel:  UILabel!
    private var longitudeLabel: UILabel!
    private var altitudeLabel:  UILabel!
    private var angleLabel:     UILabel!
    private var directionLabel: UILabel!
    private var targetLabel:    UILabel!
    
    
    private var compassImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        imageView.image = UIImage(named: "degrees")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .label
        return imageView
    }()
    
    private let toolBar: UIToolbar = {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 100, height: 34))
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        toolBar.tintColor = .systemRed
        return toolBar
    }()
    
    private var targetButton: UIBarButtonItem!
    private var shareButton: UIBarButtonItem!
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAppearance()
        configureToolBar()
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
    func configureToolBar() {
        view.addSubview(toolBar)
        NSLayoutConstraint.activate([
            toolBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            toolBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            toolBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        targetButton = UIBarButtonItem(title: "Add target", style: .plain, target: self, action: #selector(targetButtonDidTap))
        shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareButtonDidTap))
        
        toolBar.items = [
            UIBarButtonItem(systemItem: .flexibleSpace),
            targetButton,
            UIBarButtonItem(systemItem: .flexibleSpace),
            shareButton]
    }
    
    func configureTopInfoLabels() {
        coordinatesContainerStack = createVStack()
        
        localityLabel  = UILabel(textStyle: .largeTitle)
        latitudeLabel  = UILabel(textStyle: .title2)
        longitudeLabel = UILabel(textStyle: .title2)
        altitudeLabel  = UILabel(textStyle: .title2)
        
        latitudeLabel.font  = .monospacedSystemFont(ofSize: 17, weight: .regular)
        longitudeLabel.font = .monospacedSystemFont(ofSize: 17, weight: .regular)
        altitudeLabel.font  = .monospacedSystemFont(ofSize: 17, weight: .regular)
        
        view.addSubview(coordinatesContainerStack)
        NSLayoutConstraint.activate([
            coordinatesContainerStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            coordinatesContainerStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            coordinatesContainerStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
        
        coordinatesContainerStack.addArrangedSubview(localityLabel)
        coordinatesContainerStack.addArrangedSubview(latitudeLabel)
        coordinatesContainerStack.addArrangedSubview(longitudeLabel)
        coordinatesContainerStack.addArrangedSubview(altitudeLabel)
    }
    
    func configureCompassComponents() {
        let angleArrow = UIImageView()
        angleArrow.image = UIImage(systemName: "arrowtriangle.down.fill")
        angleArrow.translatesAutoresizingMaskIntoConstraints = false
        angleArrow.tintColor = .systemRed
        view.addSubview(angleArrow)
        
        view.addSubview(compassImageView)
        NSLayoutConstraint.activate([
            compassImageView.topAnchor.constraint(equalTo: coordinatesContainerStack.bottomAnchor, constant: 48),
            compassImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            compassImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            compassImageView.heightAnchor.constraint(equalTo: compassImageView.widthAnchor),
            
            angleArrow.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            angleArrow.bottomAnchor.constraint(equalTo: compassImageView.topAnchor)
        ])
    }
    
    func configureAngleAndDirectionLabels() {
        directionContainerStack = createVStack()
        directionContainerStack.alignment = .center
        
        angleLabel = UILabel(textStyle: .largeTitle)
        directionLabel = UILabel(textStyle: .largeTitle)
        targetLabel = UILabel(textStyle: .title3)
        targetLabel.text = "No target"
        targetLabel.alpha = 0.6
        
        directionContainerStack.addArrangedSubview(angleLabel)
        directionContainerStack.addArrangedSubview(directionLabel)
        directionContainerStack.addArrangedSubview(targetLabel)
        
        view.addSubview(directionContainerStack)
        
        NSLayoutConstraint.activate([
            directionContainerStack.centerXAnchor.constraint(equalTo: compassImageView.centerXAnchor),
            directionContainerStack.centerYAnchor.constraint(equalTo: compassImageView.centerYAnchor),
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
    
    func targetButtonDidTap() {
        presenter.targetButtonDidTap()
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
    
    func updateLocality(_ locality: String) {
        localityLabel.text = locality
    }
    
    func rotateCompass(angle: Double) {
        UIView.animate(withDuration: 0.2) {
            self.compassImageView.transform = CGAffineTransform(rotationAngle: angle)
        }
    }
    
    func updateTargetState(label: String, button: String) {
        targetLabel.text = label
        targetButton.title = button
    }
    
    func setNormalBackground() {
        UIView.animate(withDuration: 0.4) {
            self.view.backgroundColor = .systemBackground
        }
    }
    
    func setTargetBackground() {
        UIView.animate(withDuration: 0.4) {
            self.view.backgroundColor = .systemGreen
        }
    }
    
    func presentAddTargetAlert(with text: String)  {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add target", message: "", preferredStyle: .alert)
        alert.addTextField { alertTextField in
            alertTextField.text = text
            alertTextField.keyboardType = .numberPad
            textField = alertTextField
        }
        
        let addAction = UIAlertAction(title: "Add", style: .default) { [weak self]_ in
            self?.presenter.addTarget(angle: textField.text)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
}

