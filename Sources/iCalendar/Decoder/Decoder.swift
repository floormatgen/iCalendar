import Foundation

extension iCal {

/// Decodes iCalendar objects
open class Decoder: @unchecked Sendable {

    /// Creates a new ``iCal.Decoder``.
    public init() {

    }
    
    // MARK: - Properties

    private var _supportedComponents: [any iCal.Component.Type] = [ iCal.Calendar.self, iCal.Event.self ]

    // MARK: - Accessors

    open var supportedComponents: [any iCal.Component.Type] {
        get { _read { _supportedComponents } }
        set { _write { _supportedComponents = newValue } }
    }
    
    // MARK: - Calendar Decoding

    open func decodeCalendar(from data: Data) throws -> iCal.Calendar {
        return try decodeCalendar(from: String(bytes: data, encoding: .utf8)!)
    }

    open func decodeCalendar(from string: String) throws -> iCal.Calendar {
        return _read { preconditionFailure("Not Implemented!") }
    }

    open func decodeCalendars(from data: Data) throws -> [iCal.Calendar] {
        return try decodeCalendars(from: String(bytes: data, encoding: .utf8)!)
    }

    open func decodeCalendars(from string: String) throws -> [iCal.Calendar] {
        return _read { preconditionFailure("Not Implemented!") }
    }
    
    // MARK: -- Syncronization --
    
    /// Internal queue for syncronization.
    final internal let _queue = DispatchQueue(label: "iCal.Decoder", attributes: .concurrent)
    
    /// Thread-safe read
    final internal func _read<R>(operation: () throws -> R) rethrows -> R {
        return try _queue.sync(execute: operation)
    }
    
    /// Thread-safe write
    final internal func _write<R>(operation: () throws -> R) rethrows -> R {
        return try _queue.sync(flags: .barrier, execute: operation)
    }

}

} // extension iCal
