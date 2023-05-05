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
    
    private let angleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .largeTitle)
        return label
    }()
    
    private let directionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .title2)
        label.text = "north"
        return label
    }()
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        view.addSubview(angleLabel)
        view.addSubview(directionLabel)
        NSLayoutConstraint.activate([
            angleLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            angleLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            
            directionLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            directionLabel.topAnchor.constraint(equalTo: angleLabel.bottomAnchor),
        ])
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

