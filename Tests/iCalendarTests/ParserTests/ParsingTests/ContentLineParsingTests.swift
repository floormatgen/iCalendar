import Testing

@testable import iCalendar

extension ParserTests.ParsingTests {

@Suite("Content Line Tests")
struct ContentLineParsingTests {

    // MARK: - quoted_string Tests

    @Test("quoted_string extracts inner string", arguments: [
        ("\"hello, world\"", "hello, world"),
        ("\"\"", ""),
        ("\";:,\"", ";:,"),
    ])
    func test_quoted_string_extractsInnerString(input: String, expected: String) throws {
        #expect(try iCal.Parser.quoted_string.parse(input) == expected, "Input string not properly stripped of DQUOTE")
    }

}

} // extension ParserTests.ParsingTests