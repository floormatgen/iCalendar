import Foundation

extension iCal {

/// This value type is used to identify values that specify a
/// precise calendar date and time of day.
///
/// See [**3.3.5.  Date-Time**](https://datatracker.ietf.org/doc/html/rfc5545#section-3.3.5).
public enum DateTime: DataType {
    case localTime(components: DateComponents)
    case absoluteTime(Date)
    case localTimeWithTimeZone(tzid: String, components: DateComponents)
    
    public func dateComponents(with zone: TimeZone = .current, calendar: Foundation.Calendar = .current) -> DateComponents {
        switch self {
        case .localTime(let components):
            return components
        case .localTimeWithTimeZone(_, let components):
            return components
        case .absoluteTime(let date):
            return calendar.dateComponents(in: zone, from: date)
        }
    }

}

} // extension iCal

extension iCal.DateTime: LosslessStringConvertible {

    public var description: String {
        return ""
    }

    public init(_ string: some StringProtocol) {
        fatalError()
    }

}