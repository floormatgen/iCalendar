extension iCal {

/// This value type is used to identify properties that contain
/// a duration of time.
///
/// See [**3.3.6.  Duration**](https://datatracker.ietf.org/doc/html/rfc5545#section-3.3.6).
public struct Duration: DataType {
    
    public enum Direction: Sendable {
        case forward
        case backward
    }
    
    public var direction: Direction?
    public var weeks: UInt?
    public var days: UInt?
    public var hours: UInt?
    public var minutes: UInt?
    public var seconds: UInt?
    
    public init(direction: Direction? = nil, weeks: UInt) {
        self.direction = direction
        self.weeks = weeks
    }
    
    public init(direction: Direction? = nil, days: UInt, hours: UInt? = nil) {
        self.direction = direction
        self.days = days
        self.hours = hours
    }
    
    public init(direction: Direction? = nil, days: UInt? = nil, hours: UInt, minutes: UInt? = nil) {
        self.direction = direction
        self.days = days
        self.hours = hours
        self.minutes = minutes
    }
    
    public init(direction: Direction? = nil, days: UInt? = nil, hours: UInt, minutes: UInt, seconds: UInt? = nil) {
        self.direction = direction
        self.days = days
        self.hours = hours
        self.minutes = minutes
        self.seconds = seconds
    }
    
    public var isValid: Bool {
        // dur-value  = (["+"] / "-") "P" (dur-date / dur-time / dur-week)
        //
        // dur-date   = dur-day [dur-time]
        // dur-time   = "T" (dur-hour / dur-minute / dur-second)
        // dur-week   = 1*DIGIT "W"
        // dur-hour   = 1*DIGIT "H" [dur-minute]
        // dur-minute = 1*DIGIT "M" [dur-second]
        // dur-second = 1*DIGIT "S"
        // dur-day    = 1*DIGIT "D"
        if weeks != nil {
            return (days == nil && hours == nil && minutes == nil && seconds == nil)
        } else {
            return (
                (days != nil && hours == nil && minutes == nil && seconds == nil) ||
                (hours != nil) && ((minutes == nil && seconds == nil) ||
                                   (minutes != nil && seconds == nil) ||
                                   (minutes != nil && seconds != nil))
            )
        }
    }
    
}

} // extension iCal

extension iCal.Duration: LosslessStringConvertible {
    
    /// Creates an empty ``ICDuration``.
    ///
    /// > Important: An empty ``ICDuration`` is not valid (`isValid == false`).
    package init(direction: Direction? = nil, weeks: UInt? = nil, days: UInt? = nil, hours: UInt? = nil, minutes: UInt? = nil, seconds: UInt? = nil) {
        self.direction = direction
        self.weeks = weeks
        self.days = days
        self.hours = hours
        self.minutes = minutes
        self.days = days
    }
    
    public var description: String {
        
        var result = ""
        if let direction = direction {
            switch direction {
            case .forward:
                result += "+"
            case .backward:
                result += "-"
            }
        }
        
        result += "P"
        if let weeks = weeks {
            result += "\(weeks)W"
            return result
        }
        
        if let days = days {
            result += "\(days)D"
        }
        
        result += "T"
        if let hours = hours { result += "\(hours)H" }
        if let minutes = minutes { result += "\(minutes)M" }
        if let seconds = seconds { result += "\(seconds)S" }
        
        return result
    }
    
    public init?(_ string: some StringProtocol) {
        self.init()
        var iterator = string.makeIterator()
        
        // dur-value  = (["+"] / "-") "P" (dur-date / dur-time / dur-week)
        guard let firstChar = iterator.next() else { return nil }
        switch firstChar {
        case "+":
            self.direction = .forward
            guard iterator.next() == "P" else { return nil }
        case "-":
            self.direction = .backward
            guard iterator.next() == "P" else { return nil }
        case "P":
            break
        default:
            return nil
        }
        
        // dur-date   = dur-day [dur-time]
        // dur-time   = "T" (dur-hour / dur-minute / dur-second)
        // dur-week   = 1*DIGIT "W"
        // dur-hour   = 1*DIGIT "H" [dur-minute]
        // dur-minute = 1*DIGIT "M" [dur-second]
        // dur-second = 1*DIGIT "S"
        // dur-day    = 1*DIGIT "D"
        var buffer = ""
        var requiresTime = false
        var providedTime = false
        while let c = iterator.next() {
            if c.isNumber {
                buffer.append(c)
                continue
            }
            guard !buffer.isEmpty || c == "T" else { return nil }
            switch c {
            case "W":
                guard let value = UInt(buffer) else { return nil }
                weeks = value
            case "D":
                guard let value = UInt(buffer),
                        weeks == nil else { return nil }
                days = value
            case "T":
                guard buffer.isEmpty,
                        days != nil,
                        weeks == nil else { return nil }
                requiresTime = true
            case "H":
                guard let value = UInt(buffer),
                      providedTime == false else { return nil }
                hours = value
                providedTime = true
            case "M":
                guard let value = UInt(buffer),
                      providedTime == true else { return nil }
                minutes = value
            case "S":
                guard let value = UInt(buffer) else { return nil }
                seconds = value
            default:
                return nil
            }
            buffer = ""
        }
        
        guard requiresTime == providedTime else { return nil }
    }
    
}
