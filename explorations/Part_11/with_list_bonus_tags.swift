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
    case list([StringNode])

    init(_ string:String) {
        self = .content(string)
    }
    
    init(prefix:String, content:String, suffix:String) {
        self = .container((prefix: prefix, content: .content(content), suffix: suffix))
    }
    
    init(prefix:String, content:StringNode, suffix:String) {
        self = .container((prefix: prefix, content: content, suffix: suffix))
    }
    
    init(_ content:StringNode...) {
        self = .list(content)
    }
    
    public init(@StringNodeBuilder content: () -> [StringNode]) {
        self = .list(content())
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
        case .list(let nodeArray):
            return Self.stringify(nodeSet: nodeArray)
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
        case .list(let nodeArray):
            return indentStringify(nodeSet:nodeArray, startLevel:level, separator:"\n")
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
    
    public static func buildArray(_ components: [[StringNode]]) -> [StringNode] {
        return components.flatMap { $0 }
    }
    
//    public static func buildExpression(_ expression: String) -> [StringNode] {
//        [.content(expression)]
//    }
//
//    static func buildExpression(_ components: String...) -> [StringNode] {
//        components.compactMap { .content($0) }
//    }
//
//    static func buildExpression(_ components: [String]...) -> [StringNode] {
//        components.flatMap { $0 }.compactMap { .content($0) }
//    }
    
    public static func buildExpression(_ expression: Nodeable) -> [StringNode] {
        [expression.asStringNode]
    }
    
    static func buildExpression(_ components: Nodeable...) -> [StringNode] {
        components.compactMap { $0.asStringNode }
    }
    
    static func buildExpression(_ components: [Nodeable]...) -> [StringNode] {
        components.flatMap { $0 }.compactMap { $0.asStringNode }
    }
    
}

struct Document {
    enum RenderStyle {
        case minimal
        case indented
    }
    
    let content:[StringNode]
    init(@StringNodeBuilder content: () -> [StringNode]) {
        self.content = content()
    }
    
    func render(style: RenderStyle = .indented) -> String {
        switch style {
        case .indented:
            return StringNode.indentStringify(nodeSet: content, separator:"\n")
        case .minimal:
            return StringNode.stringify(nodeSet: content)
        }
    }
}


protocol Nodeable {
    var asStringNode:StringNode { get }
}

extension String:Nodeable {
    var asStringNode: StringNode {
        .content(self)
    }
}

struct FunTag:Nodeable {
    let prefix:String = "<FUNTAG>"
    let suffix:String = "</FUNTAG>"
    let content:StringNode
    
    var asStringNode: StringNode {
        .container((prefix: prefix, content: content, suffix: suffix))
    }
}
extension FunTag {
//    init(_ content:()->Nodeable) {
//        self.content = content().asStringNode
//    }
    init(@StringNodeBuilder content: () -> [StringNode]) {
        self.content = .list(content())
    }
}



struct AttributedTag:Nodeable {
    
    let name:String
    let id:Int
    
    var prefix: String { "<\(name) attribute=\"\(id)\">" }
    var suffix: String { "</\(name)>" }
    
    var content: StringNode
    
    init(name:String, attribute:Int, @StringNodeBuilder content: () -> [StringNode]) {
        self.name = name
        self.id = attribute
        self.content = .list(content())
    }
    
    var asStringNode: StringNode {
        .container((prefix: prefix, content: content, suffix: suffix))
    }
}

struct Repeater:Nodeable {
    
    let count:Int
    var content: StringNode
    
    init(count:Int, @StringNodeBuilder content: () -> [StringNode]) {
        self.count = count
        self.content = .list(content())
    }
    
    var asStringNode: StringNode {
        var tmp:[StringNode] = []
        for _ in 0..<count {
            tmp.append(content)
        }
        return .list(tmp)
    }
}

let document = Document {
    "Header"
    oneMoreDown
    FunTag(content: bracketedMessage)
    AttributedTag(name: "MEANING", attribute: 42) {
        FunTag {
            "Test"
            bracketedMessage
        }
    }
    Repeater(count: 3) {
        "Hi!"
    }
    "Footer"
}

print(document.render())
print(document.render(style: .minimal))
