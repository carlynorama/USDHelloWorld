public struct Indent {
    let count:Int
    let indentString:String
    let prefix:String
    public init(count:Int, indentString:String = "\t", prefix:String="") {
        self.count = count
        self.indentString = indentString
        self.prefix = prefix
    }
    
    var value:String {
        var tmp = ""
        for _ in 0..<count {
            tmp.append(indentString)
        }
        return "\(prefix)\(tmp)"
    }
}


indirect enum StringNode {
    case content(String)
    case container((prefix:String, content:StringNode, suffix:String))
    

    init(_ string:String) {
        self = .content(string)
    }
    
    init(prefix:String, content:String, suffix:String) {
        self = .container((prefix: prefix, content: .content(content), suffix: suffix))
    }
    
    init(prefix:String, content:StringNode, suffix:String) {
        self = .container((prefix: prefix, content: content, suffix: suffix))
    }
    
    private static func stringify(node:StringNode) -> String {
        switch node {
        case .content(let s):
            return s
        case .container(let tuple):
            let prefix = tuple.prefix
            let suffix = tuple.suffix
            let content = stringify(node: tuple.content)
            return "\(prefix)\(content)\(suffix)"
        }
    }
    
    static func stringify(nodeSet:[StringNode]) -> String {
        nodeSet.map({ $0.makeString() }).joined()
    }
    
    func makeString() -> String {
        Self.stringify(node: self)
    }
    
    private static func indentStringify(node: StringNode, level:Int = 0) -> String {
        let indent = Indent(count: level, prefix: "")
        let ind = indent.value
        
        switch node {
        case .content(let s):
            return "\(ind)\(s)"
        case .container(let tuple):
            let prefix = tuple.prefix
            let suffix = tuple.suffix
            let content = indentStringify(node: tuple.content, level: level + 1)
            return "\(ind)\(prefix)\("\n")\(content)\("\n")\(ind)\(suffix)"
        }
    }
    static func indentStringify(nodeSet:[StringNode],
                                startLevel:Int = 0,
                                separator:String="") -> String {
        nodeSet.map({
            $0.indentedString(startLevel: startLevel)
        }).joined(separator: separator)
    }

    func indentedString(startLevel:Int = 0) -> String {
        Self.indentStringify(node: self, level: startLevel)
    }
    
}


let message:StringNode = .content("I have a message")
let bracketedMessage = StringNode(prefix:"<p>", content: message, suffix:"</p>")
let oneMoreDown = StringNode(prefix:"<body>", content: bracketedMessage, suffix:"</body>")

print(bracketedMessage.makeString())
print(oneMoreDown.makeString())

@resultBuilder
enum StringNodeBuilder {
    static func buildBlock(_ components: [StringNode]...) -> [StringNode] {
        buildArray(components)
    }
    
    public static func buildExpression(_ expression: StringNode) -> [StringNode] {
        [expression]
    }
    
    public static func buildExpression(_ expression: String) -> [StringNode] {
        [.content(expression)]
    }


    public static func buildArray(_ components: [[StringNode]]) -> [StringNode] {
        return components.flatMap { $0 }
    }
}

struct Document {
    let content:[StringNode]
    init(@StringNodeBuilder content: () -> [StringNode]) {
        self.content = content()
    }
    
    func render() -> String {
        StringNode.indentStringify(nodeSet: content)
    }
}

let document = Document {
    "Header"
    oneMoreDown
    "Footer"
}

print(document.render())
