import Testing

import Foundation

@testable import iCalendar

extension ParserTests.CharSetTests {

@Suite("Content Line Tests")
struct ContentLineCharSetTests {

    // MARK: - QSAFE_CHAR tests

    @Test("QSAFE_CHAR does not contain DQUOTE.")
    func test_QSAFE_CHAR_doesNotContain_DQUOTE() {
        #expect(!iCal.Parser.CharSet.QSAFE_CHAR.contains("\""), "QSAFE_CHAR contains DQUOTE")
    }

    @Test("QSAFE_CHAR does not contain CONTROL characters.", arguments: controlCharacters)
    func test_QSAFE_CHAR_doesNotContainControlCharacters(s: Unicode.Scalar) {
        #expect(!iCal.Parser.CharSet.QSAFE_CHAR.contains(s), "QSAFE_CHAR contains CONTROL char \(s)")
    }

    // MARK: - SAFE_CHAR tests

    @Test("SAFE_CHAR does not contain unsafe characters.", arguments: [ "\"", ";", ":", "," ])
    func test_SAFE_CHAR_returnsFalseForUnsafeChar(s: Unicode.Scalar) {
        #expect(!iCal.Parser.CharSet.SAFE_CHAR.contains(s), "SAFE_CHAR contains unsafe char \(s)")
    }

    @Test("SAFE_CHAR does not contain CONTROL characters.", arguments: controlCharacters)
    func test_SAFE_CHAR_returnsFalseForControlChar(s: Unicode.Scalar) {
        #expect(!iCal.Parser.CharSet.SAFE_CHAR.contains(s), "SAFE_CHAR contains CONTROL char \(s)")
    }

    // MARK: - CONTROL tests

    @Test("CONTROL contains CONTROL characters", arguments: controlCharacters)
    func test_CONTROL_contains_CONTROL_characters(s: Unicode.Scalar) {
        #expect(iCal.Parser.CharSet.CONTROL.contains(s), "CONTROL does not contain CONTROL char \(s)")
    }

    @Test("CONTROL does not contain printable ASCII characters", arguments: printableASCIICharacters)
    func test_CONTROL_doesNotContainPrintable_ASCII_characters(s: Unicode.Scalar) {
        #expect(!iCal.Parser.CharSet.CONTROL.contains(s), "CONTROL contains printable ASCII char \(s)")
    }

}

} // extension ParserTests.CharSetTests

// MARK: - Helper Methods

fileprivate var controlCharacters: [Unicode.Scalar] {
    var chars: [Unicode.Scalar] = []

    for n: UInt8 in 0x00...0x08 {
        chars.append(Unicode.Scalar(n))
    }

    for n: UInt8 in 0x0A...0x1F {
        chars.append(Unicode.Scalar(n))
    }

    chars.append(Unicode.Scalar(0x7F))

    return chars
}

fileprivate var printableASCIICharacters: [Unicode.Scalar] {
    var chars: [Unicode.Scalar] = []

    for n: UInt8 in 0x20...0x7E {
        chars.append(Unicode.Scalar(n))
    }

    return chars
}