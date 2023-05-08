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
    func updateTargetInfo(targetText: String?)
    
    func setNormalBackground()
    func setTargetBackground()
    
    func rotateCompass(angle: Double)
    func presentShareController(textToShare text: String)
}

final class CompassViewController: UIViewController {
    var presenter: CompassPresenter!
    
    // MARK: - UI Elements
    private var coordinatesContainerStack: UIStackView!
    private var directionContainerStack:   UIStackView!
    
    private let localityLabel  = UILabel(textStyle: .largeTitle)
    private let latitudeLabel  = UILabel(withMonoFontSize: 17)
    private let longitudeLabel = UILabel(withMonoFontSize: 17)
    private let altitudeLabel  = UILabel(withMonoFontSize: 17)
    private let angleLabel     = UILabel(textStyle: .largeTitle)
    private let directionLabel = UILabel(textStyle: .largeTitle)
    
    private let compassImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        imageView.image = UIImage(named: "degrees")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .label
        return imageView
    }()
    
    private let targetTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Add target"
        textField.textAlignment = .center
        textField.textColor = .systemRed
        return textField
    }()
    
    private let toolBar: UIToolbar = {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 100, height: 34))
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        toolBar.tintColor = .systemRed
        return toolBar
    }()
    
    private lazy var targetPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        return picker
    }()
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAppearance()
        configureToolBar()
        configureCompassComponents()
        configureDirectionSection()
        configureLocationLabels()
    }
    
    // MARK: - Event Handling
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        targetTextField.resignFirstResponder()
    }
}

// MARK: - Private Methods
private extension CompassViewController {
    func configureAppearance() {
        title = "Compass"
        view.backgroundColor = .systemBackground
    }
    
    func configureToolBar() {
        view.addSubview(toolBar)
        NSLayoutConstraint.activate([
            toolBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            toolBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            toolBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        toolBar.items = [UIBarButtonItem(systemItem: .flexibleSpace),
                         UIBarButtonItem(barButtonSystemItem: .action,target: self, action: #selector(shareButtonDidTap))]
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
    
    func configureDirectionSection() {
        directionContainerStack = createVStack()
        
        view.addSubview(directionContainerStack)
        NSLayoutConstraint.activate([
            directionContainerStack.centerXAnchor.constraint(equalTo: compassImageView.centerXAnchor),
            directionContainerStack.centerYAnchor.constraint(equalTo: compassImageView.centerYAnchor),
        ])
        
        targetTextField.inputView = targetPicker
        
        [angleLabel, directionLabel, targetTextField].forEach { directionContainerStack.addArrangedSubview($0) }
    }
    
    func configureLocationLabels() {
        coordinatesContainerStack = createVStack()
        
        view.addSubview(coordinatesContainerStack)
        NSLayoutConstraint.activate([
            coordinatesContainerStack.topAnchor.constraint(equalTo: compassImageView.bottomAnchor, constant: 16),
            coordinatesContainerStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            coordinatesContainerStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
        [latitudeLabel, longitudeLabel, altitudeLabel].forEach { $0.alpha = 0.7 }
        [localityLabel, latitudeLabel, longitudeLabel, altitudeLabel].forEach { coordinatesContainerStack.addArrangedSubview($0) }
    }
    
    func createVStack() -> UIStackView {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.alignment = .center
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
    
    func updateLocality(_ locality: String) {
        localityLabel.text = locality
    }
    
    func rotateCompass(angle: Double) {
        UIView.animate(withDuration: 0.2) {
            self.compassImageView.transform = CGAffineTransform(rotationAngle: angle)
        }
    }
    
    func updateTargetInfo(targetText: String?) {
        targetTextField.text = targetText
    }
    
    func setNormalBackground() {
        guard view.backgroundColor != .systemBackground else { return }
        UIView.animate(withDuration: 0.4) {
            self.view.backgroundColor = .systemBackground
            self.targetTextField.textColor = .systemRed
        }
    }
    
    func setTargetBackground() {
        guard view.backgroundColor != .systemGreen else { return }
        UIView.animate(withDuration: 0.4) {
            self.view.backgroundColor = .systemGreen
            self.targetTextField.textColor = .white
        }
    }
    
    // https://stackoverflow.com/questions/58911158/why-is-uiactivityviewcontroller-displaying-auto-constraint-errors-in-console
    func presentShareController(textToShare text: String) {
        let activityVC = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        DispatchQueue.main.async {
            self.present(activityVC, animated: true)
        }
    }
}

// MARK: - UIPickerViewDataSource
extension CompassViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return presenter.getNumberOfTargets()
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return presenter.getTitleForTarget(at: row)
    }
}

// MARK: - UIPickerViewDelegate
extension CompassViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        presenter.didSelectTarget(row)
        targetTextField.resignFirstResponder()
    }
}

