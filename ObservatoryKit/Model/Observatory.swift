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
    
    /**
     * The date for which the events were calculated.
     */
    private var calculatedForDate: Date? = nil
    
    public var events = [AstronomicalEvent]()
    
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
        // If the calculated date is within half a day of the set date, nor data is recalculated.
        if calculatedForDate != nil && fabs(calculatedForDate!.timeIntervalSince(date)) < 0.5*Date.lengthOfDay {
            return
        }
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
        events = AstronomicalEvent.removeDuplicates(events: events)
        let startDate = Date(julianDay: date.julianDay-1).midnight
        let endDate = Date(julianDay: date.julianDay + Double(Observatory.numberOfDays+1)).midnight
        events = AstronomicalEvent.filter(events: events, start: startDate, end: endDate)
        events.sort {
            $0.date < $1.date
        }
        calculatedForDate = date
    }
    
    public var description: String {
        get {
            var string = "Observatory \(self.name) at \(self.location) on date: \(self.date)\n"
            var i = 1
            for event in events {
                string = string + "[\(i)] \(event)\n"
                i = i + 1
            }
            return string
        }
    }
}
