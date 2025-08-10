import Foundation

extension iCal {

public protocol ComponentContainer: iCal.Component {
    static var supportedComponents: [any iCal.Component.Type] { get }

    init(from components: some Sequence<iCal.PropertyComponents>, children: some Sequence<any iCal.Component>) throws
}

} // extension iCal

public extension iCal.ComponentContainer {

    init(from components: some Sequence<iCal.PropertyComponents>) throws {
        try self.init(from: components, children: [])
    }

}