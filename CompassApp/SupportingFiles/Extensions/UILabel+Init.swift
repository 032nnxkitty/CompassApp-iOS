//
//  UILabel+Init.swift
//  CompassApp
//
//  Created by Arseniy Zolotarev on 07.05.2023.
//

import UIKit

extension UILabel {
    convenience init(textStyle: UIFont.TextStyle) {
        self.init(frame: .zero)
        self.font = .preferredFont(forTextStyle: textStyle)
    }
}