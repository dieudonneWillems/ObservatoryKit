//
//  ObservatoryKitTests.swift
//  ObservatoryKitTests
//
//  Created by Don Willems on 22/10/2020.
//

import XCTest
import CelestialMechanics
@testable import ObservatoryKit

class ObservatoryKitTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.year = 2020
        dateComponents.month = 11
        dateComponents.day = 1
        dateComponents.timeZone = TimeZone(abbreviation: "GMT")
        dateComponents.hour = 0
        dateComponents.minute = 0
        dateComponents.second = 0
        let date = calendar.date(from: dateComponents)!
        let eidsvoll = GeographicLocation(latitude: 60.331/Double.rpi, longitude: 11.263/Double.rpi, elevation: 120)
        var observatory = try Observatory(with: "Eidsvoll, Norway", at: eidsvoll)
        observatory.date = date
        print(observatory)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
