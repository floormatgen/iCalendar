import Testing

@testable import iCalendar

extension ParserTests.ParsingTests {

@Suite("Content Line Tests")
struct ContentLineParsingTests {

    // MARK: - param_name Tests

    @Test("param_name can extract iana_token", arguments: [
        ("hello-world", "hello-world"),
        ("1234567890", "1234567890"),
        ("a1b2c3d4e5-f6-g7-h8-i9---j0", "a1b2c3d4e5-f6-g7-h8-i9---j0"),
        ("---", "---")
    ])
    func param_name_correctlyExtracts_iana_token(input: String, expected: String) throws {
        let result = try iCal.Parser.param_value.parse(input)
        #expect(result == expected, "param_name failed to extract iana_token [input: \(input), result: \(result), expected: \(expected)]")
    }

    @Test("prarm_name can extract x_name", arguments: [
        ("X-name", "X-name"),
        ("X-X3D-name", "X-X3D-name"),
    ])
    func param_name_correctlyExtracts_x_name(input: String, expected: String) throws {
        let result = try iCal.Parser.param_value.parse(input)
        #expect(result == expected, "param_names failed to extract x_name [input: \(input), result: \(result), expected: \(expected)]")
    }

    // MARK: - param_value Tests

    @Test("param_value can extract param_text and quoted_string", arguments: [
        ("hello world", "hello world"),
        ("\"hello, world\"", "hello, world"),
        ("a", "a"),
        ("\"a\"", "a"),
    ])
    func param_value_correctlyExtractsEither_paramtext_or_quoted_string(input: String, expected: String) throws {
        let result = try iCal.Parser.param_value.parse(input)
        #expect(result == expected, "param_value failed to extract value [input: \(input), result: \(result), expected: \(expected)]")
    }
    
    @Test("param_value can unfold content lines", arguments: [
        ("hello \r\n world", "hello world"),
        ("\"hello \r\n world\"", "hello world"),
    ])
    func param_value_correctlyUnfolds(input: String, expected: String) throws {
        let result = try iCal.Parser.param_value.parse(input)
        #expect(result == expected, "param_value failed to unfold conent line [input: \(input), result: \(result), expected: \(expected)]")
    }

    // MARK: - quoted_string Tests

    @Test("quoted_string extracts inner string", arguments: [
        ("\"hello, world\"", "hello, world"),
        ("\"\"", ""),
        ("\";:,\"", ";:,"),
    ])
    func test_quoted_string_extractsInnerString(input: String, expected: String) throws {
        let result = try iCal.Parser.quoted_string.parse(input)
        #expect(result == expected, "Input string not properly stripped of DQUOTE [input: \(input), result: \(result), expected:\(expected)]")
    }
    
    @Test("quoted_string can unfold content lines", arguments: [
        ("\"hello \r\n world\"", "hello world"),
        ("\"str\r\n ing\"", "string"),
    ])
    func quoted_string_correctlyUnfolds(input: String, expected: String) throws {
        let result = try iCal.Parser.quoted_string.parse(input)
        #expect(result == expected, "quoted_string failed to unfold content line [input: \(input), result: \(result), expected: \(expected)]")
    }

}

} // extension ParserTests.ParsingTests
