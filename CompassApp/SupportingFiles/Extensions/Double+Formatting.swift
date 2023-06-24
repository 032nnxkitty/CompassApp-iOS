//
//  Double+Formatting.swift
//  CompassApp
//
//  Created by Arseniy Zolotarev on 06.05.2023.
//

import Foundation

extension Double {
    enum Coordinates {
        case latitude
        case longitude
    }
    
    func formatCoordinate(style: Coordinates) -> String {
        let degrees = Int(self)
        let minutes = Int((self - Double(degrees)) * 60)
        let seconds = Int((self - Double(degrees)) * 3600) - ((minutes) * 60)
        
        var direction: String
        
        switch style {
        case .latitude:
            direction = degrees >= 0 ? "N" : "S"
        case .longitude:
            direction = degrees >= 0 ? "E" : "W"
        }
        
        return String(format: "%02d° %02d' %02d'' %@", abs(degrees), abs(minutes), abs(seconds), direction)
    }
    
    func formatAltitude() -> String {
        return String(format: "%@ %.0fm", "Elevation:", self)
    }
    
    func rotationAngle() -> CGFloat {
        return -(self * .pi / 180)
    }
}
