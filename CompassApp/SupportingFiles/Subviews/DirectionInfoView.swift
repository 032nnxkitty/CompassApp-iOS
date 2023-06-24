//
//  DirectionInfoView.swift
//  CompassApp
//
//  Created by Arseniy Zolotarev on 24.06.2023.
//

import UIKit

final class DirectionInfoView: UIStackView {
    // MARK: - UI Elements
    private let headingLabel   = UILabel(textStyle: .largeTitle)
    
    private let directionLabel = UILabel(textStyle: .largeTitle)
    
    // MARK: - Public Properties
    var direction: String = "" {
        didSet {
           directionLabel.text = direction
        }
    }
    
    var heading: String = "" {
        didSet {
            headingLabel.text = heading
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
private extension DirectionInfoView {
    func configure() {
        alignment = .center
        axis = .vertical
        
        [headingLabel, directionLabel].forEach {
            addArrangedSubview($0)
        }
    }
}

