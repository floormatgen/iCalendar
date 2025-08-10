extension iCal {

public protocol DataType: Sendable, Equatable, Hashable, LosslessStringConvertible {
    init?(_ string: some StringProtocol)
}

} // extension iCal

extension String: iCal.DataType { }