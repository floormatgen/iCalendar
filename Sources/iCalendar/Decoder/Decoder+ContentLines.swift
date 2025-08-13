internal extension iCal.Decoder {
    
    @available(*, deprecated, message: "Use unfold(_:) and parsers instead")
    static func contentLines(from stringData: String) -> some Sequence<Substring> {
        return stringData
            .replacingOccurrences(of: " \r\n", with: "")
            .split(separator: "\r\n")
    }
    
    static func unfold(_ stringData: String) -> String {
        return stringData
            .replacingOccurrences(of: " \r\n", with: "")
    }

}
