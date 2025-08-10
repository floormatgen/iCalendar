internal extension Decoder {

    static func contentLines(from stringData: String) -> some Sequence<Substring> {
        return stringData
            .replacingOccurrences(of: " \r\n", with: "")
            .split(separator: "\r\n")
    }

}