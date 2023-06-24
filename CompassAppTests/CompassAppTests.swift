//
//  CompassAppTests.swift
//  CompassAppTests
//
//  Created by Arseniy Zolotarev on 07.05.2023.
//

import XCTest
@testable import CompassApp

final class CompassAppTests: XCTestCase {
    func testPragueCoordinatesFormatting() {
        // Given
        let latitude: Double = 50.080050
        let longitude: Double = 14.429350
        let expectedLatitude = "50° 04' 48'' N"
        let expectedLongitude = "14° 25' 45'' E"
        
        // When
        let formattedLatitude = latitude.formatCoordinate(style: .latitude)
        let formattedLongitude = longitude.formatCoordinate(style: .longitude)
        
        // Then
        XCTAssertEqual(formattedLatitude, expectedLatitude)
        XCTAssertEqual(formattedLongitude, expectedLongitude)
    }
    
    func testSydneyCoordinatesFormatting() {
        // Given
        let latitude: Double = -33.852241
        let longitude: Double = 151.196326
        let expectedLatitude = "33° 51' 08'' S"
        let expectedLongitude = "151° 11' 46'' E"
        
        // When
        let formattedLatitude = latitude.formatCoordinate(style: .latitude)
        let formattedLongitude = longitude.formatCoordinate(style: .longitude)
        
        // Then
        XCTAssertEqual(formattedLatitude, expectedLatitude)
        XCTAssertEqual(formattedLongitude, expectedLongitude)
    }
    
    func testDenverCoordinatesFormatting() {
        // Given
        let latitude: Double = 39.748246
        let longitude: Double = -104.949006
        let expectedLatitude = "39° 44' 53'' N"
        let expectedLongitude = "104° 56' 56'' W"
        
        // When
        let formattedLatitude = latitude.formatCoordinate(style: .latitude)
        let formattedLongitude = longitude.formatCoordinate(style: .longitude)
        
        // Then
        XCTAssertEqual(formattedLatitude, expectedLatitude)
        XCTAssertEqual(formattedLongitude, expectedLongitude)
    }
}
