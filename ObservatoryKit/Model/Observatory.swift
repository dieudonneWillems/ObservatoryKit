//
//  Observatory.swift
//  ObservatoryKit
//
//  Created by Don Willems on 22/10/2020.
//

import Foundation
import AstroAtmosphericKit

public struct Observatory {
    
    public let location: GeographicLocation
    public let elevation: Double
    
    public var siderealTime: Double {
        get {
            return 0
        }
    }
    
    public var sunrise: Date? {
        get {
            return nil
        }
    }
    
    public var sunset: Date? {
        get {
            return nil
        }
    }
    
    public var sunTransitTime: Date? {
        get {
            return nil
        }
    }
    
    public init(at location: GeographicLocation, elevation: Double) {
        self.location = location
        self.elevation = elevation
    }
}
