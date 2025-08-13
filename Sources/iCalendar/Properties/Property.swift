extension iCal {

/// An individual attribute describing a calendar object or a calendar component.
///
/// See [**3.5.  Property**](https://datatracker.ietf.org/doc/html/rfc5545#section-3.5) and [**3.2.  Property Parameters**](https://datatracker.ietf.org/doc/html/rfc5545#section-3.2).
public struct Property<Value: iCal.DataType>: Sendable where Value: Sendable {
    
    /// The value of the property.
    public var value: Value
    /// A non-standard, experimental parameter.
    public var xParams: [String: String]?
    /// Some other IANA-registered iCalendar parameter.
    public var ianaTokens: [String: String]?
    
    public init(_ value: Value, xParams: [String: String]? = nil, ianaTokens: [String: String]? = nil) {
        self.value = value
        self.xParams = xParams
        self.ianaTokens = ianaTokens
    }
    
    public init(_ value: Value, params: [String: String]? = nil) {
        self.value = value
        
        guard let params = params else { return }
        self.xParams = [:]
        self.ianaTokens = [:]
        for (key, value) in params {
            if key.starts(with: "X-") {
                xParams![key] = value
            } else {
                ianaTokens![key] = value
            }
        }
        
    }

    public init?(of type: Value.Type = Value.self, from components: iCal.PropertyComponents) where Value: LosslessStringConvertible {
        guard let value = Value(String(components.value)) else { return nil }

        var params: [String : String] = [:]
        for param in components.params {
            params[String(param.key)] = String(param.value)
        }
        
        self.init(value, params: params)
    }
    
}

} // extension iCal

extension iCal.Property: Equatable where Value: Equatable { }
extension iCal.Property: Hashable where Value: Hashable { }
extension iCal.Property: Codable where Value: Codable { }