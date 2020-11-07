//
//  Observatory.swift
//  ObservatoryKit
//
//  Created by Don Willems on 22/10/2020.
//

import Foundation
import CelestialMechanics
//import AstroAtmosphericKit

public enum TwilightCondition {
    case day
    case civilTwilight
    case nauticalTwilight
    case astronomicalTwilight
    case night
}

public protocol ObservatoryWeatherProvider {
    
}

public struct Observatory : CustomStringConvertible {
    
    private static let numberOfDays = 7
    
    public let location: GeographicLocation
    public var date : Date = Date() {
        didSet {
            do {
                try recalculate()
            } catch {
                print("WARNING: Encountered error when setting the date \(error)")
            }
        }
    }
    
    private var events = [AstronomicalEvent]()
    
    public var siderealTime: Double {
        get {
            return meanSiderealTime
        }
    }
    
    private var meanSiderealTime: Double
    private var illuminatedFractionMoon: Double = 0.0
    
    public let name: String
    
    public init(with name: String, at location: GeographicLocation, on date: Date = Date()) throws {
        self.location = location
        self.date = date
        self.meanSiderealTime = 0.0
        self.name = name
        try self.recalculate()
    }
    
    private mutating func recalculate() throws {
        events.removeAll()
        let sun = Sun.sun
        let moon = Moon.moon
        let jd0 = date.julianDay
        for index in -1...Observatory.numberOfDays {
            let jd = jd0 + Double(index)
            let ndate = Date(julianDay: jd)
            let rtsSun = try sun.risingTransitAndSetting(at: ndate, and: location)
            let rtsMoon = try moon.risingTransitAndSetting(at: ndate, and: location)
            events.append(contentsOf: rtsSun)
            events.append(contentsOf: rtsMoon)
        }
        events.sort {
            $0.date < $1.date
        }
    }
    
    public var description: String {
        get {
            var string = "Observatory \(self.name) at \(self.location) on date: \(self.date)\n"
            for event in events {
                string = string + "\(event)\n"
            }
            return string
        }
    }
}
