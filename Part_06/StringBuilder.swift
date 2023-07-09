// https://www.hackingwithswift.com/swift/5.4/result-builders
// https://github.com/apple/swift-evolution/blob/main/proposals/0289-result-builders.md
import Foundation

@resultBuilder
struct StringBuilder {
    static func buildBlock(_ parts: String...) -> String {
        parts.joined(separator: "\n")
    }

    static func buildOptional(_ component:String?) -> String {
        component ?? ""
    }

    static func buildEither(first component: String) -> String {
        return component
    }

    static func buildEither(second component: String) -> String {
        return component
    }

    static func buildArray(_ components: [String]) -> String {
        components.joined(separator: "\n")
    }
}