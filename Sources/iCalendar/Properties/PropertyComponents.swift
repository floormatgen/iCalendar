extension iCal {

public struct PropertyComponents {

    public struct Param {
        var key: Substring
        var value: Substring
    }

    public var name: Substring
    public var value: Substring
    public var params: [Param]
    
}

} // extension iCal