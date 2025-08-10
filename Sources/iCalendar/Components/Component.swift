extension iCal {

public protocol Component {

    /// The name of the component
    /// 
    /// For example, `VEVENT` for events or `VCALENDAR` for calendar objects.
    static var componentName: String { get }

    init(from components: some Sequence<iCal.PropertyComponents>) throws
}

} // extension iCal

extension iCal.Component {

    static var beginLine: String { "BEGIN:\(componentName)" }
    static var endLine: String { "END:\(componentName)" }

}