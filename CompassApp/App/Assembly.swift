//
//  Assembly.swift
//  CompassApp
//
//  Created by Arseniy Zolotarev on 23.06.2023.
//

import UIKit

final class Assembly {
    private init() { }
    
    static func setupCompassModule() -> UIViewController {
        let compassViewModel = CompassViewModelImpl()
        let compassView = CompassViewController(viewModel: compassViewModel)
        return compassView
    }
}
