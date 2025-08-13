import Foundation

extension iCal {

/// A link to an alternate representation for a type.
/// 
/// ## From RFC [5545](https://www.rfc-editor.org/rfc/rfc5545.html#section-3.1):
///
/// Parameter Name:  ALTREP
/// 
/// Purpose:  To specify an alternate text representation for the property value.
/// 
/// Format Definition:  This property parameter is defined by the
/// following notation:
/// 
/// ```
/// altrepparam = "ALTREP" "=" DQUOTE uri DQUOTE
/// ```
/// 
/// Description:  This parameter specifies a URI that points to an
/// alternate representation for a textual property value.  A property
/// specifying this parameter MUST also include a value that reflects
/// the default representation of the text value.  The URI parameter
/// value MUST be specified in a quoted-string.
/// 
/// > Note:
///     While there is no restriction imposed on the URI schemes
///     allowed for this parameter, Content Identifier (CID) [RFC2392],
///     HTTP [RFC2616], and HTTPS [RFC2818] are the URI schemes most
///     commonly used by current implementations.
/// 
/// ### Example:
/// 
/// ```
/// DESCRIPTION;ALTREP="CID:part3.msg.970415T083000@example.com":
/// Project XYZ Review Meeting will include the following agenda
/// items: (a) Market Overview\, (b) Finances\, (c) Project Man
/// agement
/// ```
/// 
/// The "ALTREP" property parameter value might point to a "text/html"
/// content portion.
/// 
/// ```html
/// Content-Type:text/html
/// Content-Id:<part3.msg.970415T083000@example.com>
///
/// <html>
///   <head>
///    <title></title>
///   </head>
///   <body>
///     <p>
///       <b>Project XYZ Review Meeting</b> will include
///       the following agenda items:
///       <ol>
///         <li>Market Overview</li>
///         <li>Finances</li>
///         <li>Project Management</li>
///       </ol>
///     </p>
///   </body>
/// </html>
/// ```
public struct AlternateTextRepresentation: iCal.PropertyParameter {
    static public var parameterName: String { "ALTREP" }
    
    /// A ``Foundation.URL`` that points to the alternate representation of the property.
    public var url: URL

    public init?(values: [some StringProtocol]) {
        guard 
            values.count == 1, 
            let value = values.first,
            let urlString = try? iCal.Parser.quoted_string.parse(Substring(value)),
            let url = URL(string: String(urlString))
        else { return nil }
        
        self.url = url
    }

}

} // extension iCal
