//
//  Double+LatitudeLongitude.swift
//  CompassApp
//
//  Created by Arseniy Zolotarev on 06.05.2023.
//

import Foundation

extension Double {
    func formatLatitude() -> String {
        let degrees = Int(self)
        let minutes = Int((self - Double(degrees)) * 60)
        let seconds = Int((self - Double(degrees)) * 3600) - ((minutes) * 60)
        let direction = degrees >= 0 ? "N" : "S"
        return String(format: "%02d° %02d' %02d'' %@", abs(degrees), abs(minutes), abs(seconds), direction)
    }
    
    func formatLongitude() -> String {
        print(self)
        let degrees = Int(self)
        let minutes = Int((self - Double(degrees)) * 60)
        let seconds = Int((self - Double(degrees)) * 3600) - ((minutes) * 60)
        let direction = degrees >= 0 ? "E" : "W"
        return String(format: "%02d° %02d' %02d'' %@", abs(degrees), abs(minutes), abs(seconds), direction)
    }
}
