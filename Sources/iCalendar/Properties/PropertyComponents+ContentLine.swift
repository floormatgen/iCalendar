extension iCal.PropertyComponents {
    
    internal init?(fromContentLine line: Substring) {
        guard !line.isEmpty else { return nil }
        
        var currentIndex = line.startIndex
        var targetIndex: String.Index? = nil
        
        // Find the name of the property
        repeat {
            let c = line[currentIndex]
            if c == ";" {
                targetIndex = currentIndex
                break
            } else if c == ":" {
                // If another semicolon is not found, there are no other params.
                let valueStartIndex = line.index(after: currentIndex)
                let name = line[..<currentIndex]
                guard !name.isEmpty else { return nil }
                self.init(name: name, value: line[valueStartIndex...], params: [])
                return
            }
            currentIndex = line.index(after: currentIndex)
        } while currentIndex != line.endIndex
        
        guard var targetIndex else { return nil }
        
        // At least one param exists after this point.
        let name = line[..<targetIndex]
        guard !name.isEmpty else { return nil }
        var params: [Param] = []
        
        // Find each param after the name.
        targetIndex = line.index(after: currentIndex)
        currentIndex = targetIndex
        
        var nameStorage: Substring? = nil
        var encounteredColon: Bool = false
        
        loop: repeat {
            let c = line[currentIndex]
            
            switch c {
            case "\"":
                guard nameStorage != nil else { return nil }
                targetIndex = line.index(after: targetIndex)
                repeat {
                    currentIndex = line.index(after: currentIndex)
                } while currentIndex != line.endIndex && line[currentIndex] != "\""
                guard currentIndex != line.endIndex else { return nil }
                params.append(Param(key: nameStorage!, value: line[targetIndex..<currentIndex]))
                currentIndex = line.index(after: currentIndex)
                nameStorage = nil
                if line[currentIndex] == ";" {
                    targetIndex = line.index(after: currentIndex)
                } else if line[currentIndex] == ":" {
                    targetIndex = line.index(after: currentIndex)
                    encounteredColon = true
                    break loop
                } else {
                    return nil
                }
            case "=":
                guard nameStorage == nil else { return nil }
                nameStorage = line[targetIndex..<currentIndex]
                targetIndex = line.index(after: currentIndex)
            case ";":
                guard nameStorage != nil else { return nil }
                params.append(Param(key: nameStorage!, value: line[targetIndex..<currentIndex]))
                nameStorage = nil
                targetIndex = line.index(after: currentIndex)
            case ":":
                guard nameStorage != nil else { return nil }
                params.append(Param(key: nameStorage!, value: line[targetIndex..<currentIndex]))
                nameStorage = nil
                targetIndex = line.index(after: currentIndex)
                encounteredColon = true
                break loop
            default:
                break
            }
            
            currentIndex = line.index(after: currentIndex)
        } while currentIndex != line.endIndex
        
        guard encounteredColon else { return nil }
        self.init(name: name, value: line[targetIndex...], params: params)
    }

}