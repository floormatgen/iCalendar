extension iCal {

//? Not all DataTypes can be LosslessStringConvertible, as some require paramater arguments as well.
public protocol DataType: Sendable, Equatable, Hashable {
    
}

} // extension iCal

extension String: iCal.DataType { }
