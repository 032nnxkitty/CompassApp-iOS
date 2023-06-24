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
        self.text = "..."
        self.textColor = .white
        self.font = .preferredFont(forTextStyle: textStyle)
    }
    
    convenience init(withMonoFontSize size: CGFloat) {
        self.init(frame: .zero)
        self.text = "..."
        self.textColor = .lightGray
        self.font = .monospacedSystemFont(ofSize: size, weight: .regular)
    }
}
