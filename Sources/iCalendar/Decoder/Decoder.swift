import Foundation

extension iCal {

/// Decodes iCalendar objects
open class Decoder: @unchecked Sendable {
    /// Internal queue for syncronization.
    fileprivate let queue = DispatchQueue(label: "iCal.Decoder", attributes: .concurrent)

    /// Creates a new ``iCal.Decoder``.
    public init() {

    }
    
    // MARK: - Properties

    private var _supportedComponents: [any iCal.Component.Type] = [ iCal.Calendar.self, iCal.Event.self ]

    // MARK: - Accessors

    public var supportedComponents: [any iCal.Component.Type] {
        get { _read { _supportedComponents } }
        set { _write { _supportedComponents = newValue } }
    }
    
    // MARK: - Calendar Decoding

    public func decodeCalendar(from data: Data) throws -> iCal.Calendar {
        return try decodeCalendar(from: String(bytes: data, encoding: .utf8)!)
    }

    public func decodeCalendar(from string: String) throws -> iCal.Calendar {
        fatalError()
    }

    public func decodeCalendars(from data: Data) throws -> [iCal.Calendar] {
        return try decodeCalendars(from: String(bytes: data, encoding: .utf8)!)
    }

    public func decodeCalendars(from string: String) throws -> [iCal.Calendar] {
        fatalError()
    }

}

} // extension iCal

// MARK: - Syncronization
internal extension iCal.Decoder {

    func _read<R>(operation: () throws -> R) rethrows -> R {
        return try queue.sync(execute: operation)
    }

    func _write<R>(operation: () throws -> R) rethrows -> R {
        return try queue.sync(flags: .barrier, execute: operation)
    }

}