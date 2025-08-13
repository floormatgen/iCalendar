import Foundation

@preconcurrency import Parsing

extension iCal.Parser {

//? Will unfold lines before using this parser, probably not optimal but content lines are really annoying...
/// contentline   = name *(";" param ) ":" value CRLF
/// ; This ABNF is just a general definition for an initial parsing
/// ; of the content line into its property name, parameter list,
/// ; and value string
/// 
/// ; When parsing a content line, folded lines MUST first
/// ; be unfolded according to the unfolding procedure
/// ; described above.  When generating a content line, lines
/// ; longer than 75 octets SHOULD be folded according to
/// ; the folding procedure described above.
static var contentline: some Parser<Substring, ContentLineComponents> {
    Parse {
        name
        Many {
            ";"
            param
        }
        ":"
        value
        "\r\n"
    } .map(ContentLineComponents.init)
}

/// name          = iana-token / x-name
static var name: some Parser<Substring, Substring> {
    Parse {
        OneOf {
            iana_token
            x_name
        }
    }
}

/// iana-token    = 1*(ALPHA / DIGIT / "-")
/// ; iCalendar identifier registered with IANA
static var iana_token: some Parser<Substring, Substring> {
    Parse {
        Many(1) {
            OneOf {
                CharSet.ALPHA
                CharSet.DIGIT
                "-" .map { "-" }
            }
        } .map { $0.reduce("" as Substring) { $0 + $1 } }
    }
}

/// x-name        = "X-" [vendorid "-"] 1*(ALPHA / DIGIT / "-")
/// ; Reserved for experimental use.
static var x_name: some Parser<Substring, Substring> {
    Parse {
        "X-" .map { "X-" }
        Optionally {
            vendorid
            "-" .map { "-" }
        } .map { 
            guard let t = $0 else { return "" as Substring }
            return t.0 + t.1
        }
        Many(1) {
            OneOf {
                CharSet.ALPHA
                CharSet.DIGIT
            }
        } .map { $0.reduce("") { $0 + $1 } }
    } .map { $0 + $1 + $2 }
}
/// vendorid      = 3*(ALPHA / DIGIT)
/// ; Vendor identification
static var vendorid: some Parser<Substring, Substring> {
    Parse {
        Many(3) {
            OneOf {
                CharSet.ALPHA
                CharSet.DIGIT
            }
        }
    } .map { $0.reduce("" as Substring) { $0 + $1 } }
}

/// param         = param-name "=" param-value *("," param-value)
/// ; Each property defines the specific ABNF for the parameters
/// ; allowed on the property.  Refer to specific properties for
/// ; precise parameter ABNF.
static var param: some Parser<Substring, ParameterComponents> {
    Parse {
        param_name
        "="
        param_value
        Many {
            ","
            param_value
        }
    } .map {
        let name = $0.0
        let value1 = $0.1
        let otherValues = $0.2
        return ParameterComponents(parameterName: name, values: [value1] + otherValues)
    }
}

/// param-name    = iana-token / x-name
static var param_name: some Parser<Substring, Substring> {
    Parse {
        OneOf {
            iana_token
            x_name
        }
    }
} 

/// param-value   = paramtext / quoted-string
static var param_value: some Parser<Substring, Substring> {
    Parse {
        OneOf {
            quoted_string
            paramtext
        }
    }
}

/// paramtext     = *SAFE-CHAR
static var paramtext: some Parser<Substring, Substring> {
    Parse {
        CharSet.SAFE_CHAR
    }
} 

/// value         = *VALUE-CHAR
static var value: some Parser<Substring, Substring> {
    Parse {
        CharSet.VALUE_CHAR
    }
}

/// quoted-string = DQUOTE *QSAFE-CHAR DQUOTE
static var quoted_string: some Parser<Substring, Substring> {
    Parse {
        "\""
        lineFoldCompliantParser(from: CharSet.QSAFE_CHAR)
        "\""
    }
}

/// The line fold format
static var line_fold: some Parser<Substring, Void> { 
    Parse {
        Skip { " \r\n" }
    }
}

/// Create a parser that takes into account content lines from a `CharacterSet`
static func lineFoldCompliantParser(from characterSet: CharacterSet) -> some Parser<Substring, Substring> {
    var characterSet = characterSet
    characterSet.remove(Unicode.Scalar(0x20)) // The space is removed, as that is where a line fold can start
    return Many {
        OneOf {
            line_fold .map { "" as Substring }
            characterSet
            " " .map { " " }
        }
    } .map { $0.reduce("") { $0 + $1 } }
}

// MARK: - Component Types

internal struct ParameterComponents {
    var parameterName: Substring
    var values: [Substring]
}

internal struct ContentLineComponents {
    var name: Substring
    var parameters: [ParameterComponents]?
    var value: Substring
}

} // extension iCal.Parser