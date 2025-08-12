import Foundation

fileprivate typealias US = Unicode.Scalar

extension iCal.Parser {

internal enum CharSet {

    // MARK: - Content Line Characters

    /// QSAFE-CHAR    = WSP / %x21 / %x23-7E / NON-US-ASCII
    /// ; Any character except CONTROL and DQUOTE
    static var QSAFE_CHAR: CharacterSet {
        var charSet = CharacterSet()
        charSet.insert(" " as US)
        charSet.insert(US(0x21))
        charSet.insert(charactersIn: US(0x23)...US(0x7E))
        charSet.formUnion(NON_US_ASCII)
        return charSet
    }

    /// SAFE-CHAR     = WSP / %x21 / %x23-2B / %x2D-39 / %x3C-7E
    ///                / NON-US-ASCII
    /// ; Any character except CONTROL, DQUOTE, ";", ":", ","
    static var SAFE_CHAR: CharacterSet {
        var charSet = CharacterSet()
        charSet.insert(" " as US)
        charSet.insert(US(0x21))
        charSet.insert(charactersIn: US(0x23)...US(0x2B))
        charSet.insert(charactersIn: US(0x2D)...US(0x39))
        charSet.insert(charactersIn: US(0x3C)...US(0x7E))
        charSet.formUnion(NON_US_ASCII)
        return charSet
    }

    /// VALUE-CHAR    = WSP / %x21-7E / NON-US-ASCII
    /// ; Any textual character
    static var VALUE_CHAR: CharacterSet {
        var charSet = CharacterSet()
        charSet.insert(" " as US)
        charSet.insert(charactersIn: US(0x21)...US(0x7E))
        charSet.formUnion(NON_US_ASCII)
        return charSet
    }

    /// NON-US-ASCII  = UTF8-2 / UTF8-3 / UTF8-4
    /// ; UTF8-2, UTF8-3, and UTF8-4 are defined in [RFC3629]
    static var NON_US_ASCII: CharacterSet {
        // Should probably be fine ig
        // TODO: This should be accurate enough, but is not completely accurate according to the RFC.
        var charSet = CharacterSet.alphanumerics
        charSet.subtract(.letters)
        charSet.subtract(.decimalDigits)
        return charSet
    }

    /// CONTROL       = %x00-08 / %x0A-1F / %x7F
    /// ; All the controls except HTAB
    static var CONTROL: CharacterSet {
        var charSet = CharacterSet(charactersIn: US(0x00)...US(0x08))
        charSet.insert(charactersIn: US(0x0A)...US(0x1F))
        charSet.insert(US(0x7F))
        return charSet
    }

    // MARK: - Other Character Sets

    static var ALPHA: CharacterSet {
        return .letters
    }

    static var DIGIT: CharacterSet {
        return .decimalDigits
    }

}

} // extension iCal.Parser