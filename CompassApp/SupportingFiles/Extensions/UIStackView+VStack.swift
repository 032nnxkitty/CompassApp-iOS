//
//  UIStackView+VStack.swift
//  CompassApp
//
//  Created by Arseniy Zolotarev on 23.06.2023.
//

import UIKit

extension UIStackView {
    static func setupVStack() -> UIStackView {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.alignment = .center
        stack.axis = .vertical
        return stack
    }
}
