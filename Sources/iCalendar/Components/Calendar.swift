extension iCal {

/// A iCalendar object
///
/// See [**3.4.  iCalendar Object**](https://datatracker.ietf.org/doc/html/rfc5545#section-3.4).
public struct Calendar: iCal.ComponentContainer {

    public static var supportedComponents: [any iCal.Component.Type] {[ iCal.Event.self ]}
    public static var componentName: String { "VCALENDAR" }
    
    /// This property specifies the identifier corresponding to the
    /// highest version number or the minimum and maximum range of the
    /// iCalendar specification that is required in order to interpret the
    /// iCalendar object.
    ///
    /// This property **MUST** be specified once in an iCalendar object.
    ///
    /// See [**3.7.4.  Version**](https://datatracker.ietf.org/doc/html/rfc5545#section-3.7.4).
    public var version: iCal.Property<String>!
    
    /// This property specifies the identifier for the product that
    /// created the iCalendar object.
    ///
    /// The property **MUST** be specified once in an iCalendar
    /// object.
    ///
    /// See [**3.7.3.  Product Identifier**](https://datatracker.ietf.org/doc/html/rfc5545#section-3.7.3).
    public var prodID: iCal.Property<String>!
    
    /// This property defines the calendar scale used for the
    /// calendar information specified in the iCalendar object.
    ///
    /// This property can be specified once in an iCalendar
    /// object.  The default value is "GREGORIAN".
    ///
    /// See [**3.7.1.  Calendar Scale**](https://datatracker.ietf.org/doc/html/rfc5545#section-3.7.1).
    public var calScale: iCal.Property<String>?
    
    /// This property defines the iCalendar object method
    /// associated with the calendar object.
    ///
    /// This property can be specified once in an iCalendar
    /// object.
    ///
    /// See [**3.7.2.  Method**](https://datatracker.ietf.org/doc/html/rfc5545#section-3.7.2).
    public var method: iCal.Property<String>?
    
    public init(version: iCal.Property<String>,
                prodID: iCal.Property<String>,
                calScale: iCal.Property<String>? = nil) {
        self.version = version
        self.prodID = prodID
        self.calScale = calScale
    }
    
    public var isValid: Bool {
        return (version != nil && prodID != nil)
    }
    
}

} // extension iCal

extension iCal.Calendar {

    public init(from components: some Sequence<iCal.PropertyComponents>, children: some Sequence<any iCal.Component>) throws {
        #warning("TODO: Finish Implementation")
    }

}