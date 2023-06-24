//
//  UIViewController+ImpactFeedback.swift
//  CompassApp
//
//  Created by Arseniy Zolotarev on 24.06.2023.
//

import UIKit

extension UIViewController {
    func generateImpactFeedback() {
        let generator = UIImpactFeedbackGenerator()
        generator.impactOccurred()
    }
}
