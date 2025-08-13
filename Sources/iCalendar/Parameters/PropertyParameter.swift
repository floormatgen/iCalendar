extension iCal {

/// A paramter on a `iCal` property
/// 
/// ## From RFC 5545:
/// 
/// A property can have attributes with which it is associated.  These
/// "property parameters" contain meta-information about the property or
/// the property value.  Property parameters are provided to specify such
/// information as the location of an alternate text representation for a
/// property value, the language of a text property value, the value type
/// of the property value, and other attributes.
///
/// Property parameter values that contain the COLON, SEMICOLON, or COMMA
/// character separators MUST be specified as quoted-string text values.
/// Property parameter values MUST NOT contain the DQUOTE character.  The
/// DQUOTE character is used as a delimiter for parameter values that
/// contain restricted characters or URI text.  For example:
/// 
/// ```
/// DESCRIPTION;ALTREP="cid:part1.0001@example.org":The Fall'98 Wild
/// Wizards Conference - - Las Vegas\, NV\, USA
/// ```
///
/// Property parameter values that are not in quoted-strings are case-
/// insensitive.
public protocol PropertyParameter {

    /// The name of the parameter
    /// 
    /// - Important: This should always be unique. 
    /// 
    /// This name will be used to find the parameter.
    /// Custom supported parameters can be registered with the ``iCal.Decoder``.
    static var parameterName: String { get }

    /// Create a parameter from a series of values.
    /// 
    /// Most parameters will only contain 1 value, but some parameters will use multiple parameters.
    init?(values: [some StringProtocol])

}

} // extension iCal