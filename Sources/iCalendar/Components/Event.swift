extension iCal {

/// Provide a grouping of component properties that describe an
/// event.
///
/// See [**3.6.1.  Event Component**](https://datatracker.ietf.org/doc/html/rfc5545#section-3.6.1).
public struct Event: iCal.ComponentContainer {

    public static var supportedComponents: [any iCal.Component.Type] {[ ]}
    public static var componentName: String { "VEVENT" }
    
    /// `DTSTAMP`
    ///
    /// In the case of
    /// an iCalendar object that doesn't specify a "METHOD" property, this
    /// property specifies the date and time that the information
    /// associated with the calendar component was last revised in the
    /// calendar store.
    ///
    /// **Required** but **MUST NOT** occur more than once.
    ///
    /// See [**3.8.7.2.  Date-Time Stamp**](https://datatracker.ietf.org/doc/html/rfc5545#section-3.8.7.2).
    public var dtStamp: iCal.Property<iCal.DateTime>!
    
    /// `UID`
    ///
    /// This property defines the persistent, globally unique
    /// identifier for the calendar component.
    ///
    /// **Required** but **MUST NOT** occur more than once.
    ///
    /// See [**3.8.4.7.  Unique Identifier**](https://datatracker.ietf.org/doc/html/rfc5545#section-3.8.4.7).
    public var uid: iCal.Property<String>!
    
    /// This property defines a short summary or subject for the
    /// calendar component.
    ///
    /// See [**3.8.1.12.  Summary**](https://datatracker.ietf.org/doc/html/rfc5545#section-3.8.1.12).
    public var summary: iCal.Property<String>?
    
    /// This property provides a more complete description of the
    /// calendar component than that provided by the ``summary`` property.
    ///
    /// See [**3.8.1.5.  Description**](https://datatracker.ietf.org/doc/html/rfc5545#section-3.8.1.5).
    public var description: iCal.Property<String>?
    
    /// This property specifies when the calendar component begins.
    ///
    /// **REQUIRED**  if the component
    /// appears in an iCalendar object that doesn't
    /// specify the "METHOD" property; otherwise, it
    /// is OPTIONAL; in any case, it MUST NOT occur
    /// more than once.
    ///
    /// See [**3.8.2.4.  Date-Time Start**](https://datatracker.ietf.org/doc/html/rfc5545#section-3.8.2.4).
    public var dtStart: iCal.Property<iCal.DateTime>?
    
    /// This property specifies the date and time that a calendar
    /// component ends.
    ///
    /// Etiher ``dtEnd`` or ``duration`` **MAY** appear in the same ``ICEvent``,
    /// but **MUST NOT** occur in the same ``ICEvent``.
    ///
    /// See [**3.8.2.2.  Date-Time End**](https://datatracker.ietf.org/doc/html/rfc5545#section-3.8.2.2).
    public var dtEnd: iCal.Property<iCal.DateTime>?
    
    /// This property specifies a positive duration of time.
    ///
    /// Etiher ``dtEnd`` or ``duration`` **MAY** appear in the same ``ICEvent``,
    /// but **MUST NOT** occur in the same ``ICEvent``.
    ///
    /// See [**3.8.2.5.  Duration**](https://datatracker.ietf.org/doc/html/rfc5545#section-3.8.2.5).
    public var duration: iCal.Property<iCal.Duration>?
    
    public init(dtStamp: iCal.Property<iCal.DateTime>,
                uid: iCal.Property<String>,
                summary: iCal.Property<String>? = nil,
                description: iCal.Property<String>? = nil,
                dtStart: iCal.Property<iCal.DateTime>? = nil,
                dtEnd: iCal.Property<iCal.DateTime>? = nil) {
        self.dtStamp = dtStamp
        self.uid = uid
        self.summary = summary
        self.description = description
        self.dtStart = dtStart
        self.dtEnd = dtEnd
    }
    
    public init(dtStamp: iCal.Property<iCal.DateTime>,
                uid: iCal.Property<String>,
                summary: iCal.Property<String>? = nil,
                description: iCal.Property<String>? = nil,
                dtStart: iCal.Property<iCal.DateTime>? = nil,
                duration: iCal.Property<iCal.Duration>? = nil) {
        self.dtStamp = dtStamp
        self.uid = uid
        self.summary = summary
        self.description = description
        self.dtStart = dtStart
        self.duration = duration
    }
    
    public var isValid: Bool {
        return (dtStamp != nil) && (uid != nil) &&
            !(dtEnd != nil && duration != nil)
    }
    
}

} // extension iCal

extension iCal.Event {

    public init(from components: some Sequence<iCal.PropertyComponents>, children: some Sequence<any iCal.Component>) throws {
        #warning("TODO: Finish Implementation")
    }

}
