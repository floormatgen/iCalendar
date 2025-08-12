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
static let contentline = Parse {
    name
    Many {
        ";"
        param
    }
    ":"
    value
    "\r\n"
}

/// name          = iana-token / x-name
static let name = Parse {
    OneOf {
        iana_token
        x_name
    }
}

/// iana-token    = 1*(ALPHA / DIGIT / "-")
/// ; iCalendar identifier registered with IANA
static let iana_token = Parse {
    Many(1) {
        OneOf {
            CharSet.ALPHA
            CharSet.DIGIT
            "-" .map { "-" }
        }
    }
}

/// x-name        = "X-" [vendorid "-"] 1*(ALPHA / DIGIT / "-")
/// ; Reserved for experimental use.
static let x_name = Parse {
    "X-"
    Optionally {
        vendorid
        "-"
    } .map { $0 ?? [Substring]() }
    Many(1) {
        OneOf {
            CharSet.ALPHA
            CharSet.DIGIT
        }
    }
} .map { $0 + $1 }

/// vendorid      = 3*(ALPHA / DIGIT)
/// ; Vendor identification
static let vendorid = Parse {
    Many(3) {
        OneOf {
            CharSet.ALPHA
            CharSet.DIGIT
        }
    }
}

/// param         = param-name "=" param-value *("," param-value)
/// ; Each property defines the specific ABNF for the parameters
/// ; allowed on the property.  Refer to specific properties for
/// ; precise parameter ABNF.
static let param = Parse {
    param_name
    "="
    param_value
    Many {
        ","
        param_value
    }
}

/// param-name    = iana-token / x-name
static let param_name = Parse {
    OneOf {
        iana_token
        x_name
    }
}

/// param-value   = paramtext / quoted-string
static let param_value = Parse {
    OneOf {
        paramtext
        quoted_string
    }
}

/// paramtext     = *SAFE-CHAR
static let paramtext = Parse {
    CharSet.SAFE_CHAR
}

/// value         = *VALUE-CHAR
static let value = Parse {
    CharSet.VALUE_CHAR
}

/// quoted-string = DQUOTE *QSAFE-CHAR DQUOTE
static let quoted_string = Parse {
    "\""
    CharSet.QSAFE_CHAR
    "\""
}

} // extension iCal.Parser