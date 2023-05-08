//
//  Direction.swift
//  CompassApp
//
//  Created by Arseniy Zolotarev on 06.05.2023.
//

import Foundation

enum Direction: String, CaseIterable {
    case none
    
    case north
    case northEast = "north east"
    case east
    case southEast = "south east"
    case south
    case southWest = "south west"
    case west
    case northWest = "north west"
    
    init(angle: Double) {
        switch angle {
        case 337...360, 0..<22:
            self = .north
        case 22..<67:
            self = .northEast
        case 67..<112:
            self = .east
        case 112..<157:
            self = .southEast
        case 157..<202:
            self = .south
        case 202..<247:
            self = .southWest
        case 247..<292:
            self = .west
        case 292..<337:
            self = .northWest
        default:
            self = .none
        }
    }
}
