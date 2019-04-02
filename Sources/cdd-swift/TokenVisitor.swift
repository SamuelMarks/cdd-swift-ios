import SwiftSyntax

class TokenVisitor : SyntaxVisitor {
    var list = [String]()
    var tree = [Node]()
    var current: Node!

    var row = 0
    var column = 0

    override func visitPre(_ node: Syntax) {
        var syntax = "\(type(of: node))"
        if syntax.hasSuffix("Syntax") {
            syntax = String(syntax.dropLast(6))
        }
        list.append("<span class='\(syntax)' data-toggle='tooltip' title='\(syntax)'>")

        let node = Node(text: syntax)
        node.range.startRow = row
        node.range.startColumn = column
        node.range.endRow = row
        node.range.endColumn = column
        if current == nil {
            tree.append(node)
        } else {
            current.add(node: node)
        }
        current = node
    }

    override func visit(_ token: TokenSyntax) -> SyntaxVisitorContinueKind {
        current.text = escapeHtmlSpecialCharacters(token.text)
        current.token = Node.Token(kind: "\(token.tokenKind)", leadingTrivia: "", trailingTrivia: "")

        current.range.startRow = row
        current.range.startColumn = column

        token.leadingTrivia.forEach { (piece) in
            let trivia = processTriviaPiece(piece)
            list.append(trivia)
            current.token?.leadingTrivia += replaceSymbols(text: trivia)
        }
        processToken(token)
        token.trailingTrivia.forEach { (piece) in
            let trivia = processTriviaPiece(piece)
            list.append(trivia)
            current.token?.trailingTrivia += replaceSymbols(text: trivia)
        }

        current.range.endRow = row
        current.range.endColumn = column

        // print("visit \(token.tokenKind)")
        switch token.tokenKind {
            case .structKeyword: print(token);
            case .identifier(let name): print("ID FOUND: \(name)");
            default: ();
        }

        return .visitChildren
    }

    override func visitPost(_ node: Syntax) {
        list.append("</span>")
        current.range.endRow = row
        current.range.endColumn = column
        current = current.parent
    }

    private func processToken(_ token: TokenSyntax) {
        var kind = "\(token.tokenKind)"
        if let index = kind.index(of: "(") {
            kind = String(kind.prefix(upTo: index))
        }
        if kind.hasSuffix("Keyword") {
            kind = "keyword"
        }

        list.append("<span class='token \(kind)' data-toggle='tooltip' title='\(token.tokenKind)'>" + escapeHtmlSpecialCharacters(token.text) + "</span>")
        column += token.text.count
    }

    private func processTriviaPiece(_ piece: TriviaPiece) -> String {
        var trivia = ""
        switch piece {
        case .spaces(let count):
            trivia += String(repeating: "&nbsp;", count: count)
            column += count
        case .tabs(let count):
            trivia += String(repeating: "&nbsp;", count: count * 2)
            column += count * 2
        case .newlines(let count), .carriageReturns(let count), .carriageReturnLineFeeds(let count):
            trivia += String(repeating: "<br>\n", count: count)
            row += count
            column = 0
        case .backticks(let count):
            trivia += String(repeating: "`", count: count)
            column += count
        case .lineComment(let text):
            trivia += withSpanTag(class: "lineComment", text: text)
            processComment(text: text)
        case .blockComment(let text):
            trivia += withSpanTag(class: "blockComment", text: text)
            processComment(text: text)
        case .docLineComment(let text):
            trivia += withSpanTag(class: "docLineComment", text: text)
            processComment(text: text)
        case .docBlockComment(let text):
            trivia += withSpanTag(class: "docBlockComment", text: text)
            processComment(text: text)
        default:
            break
        }
        return trivia
    }

    private func withSpanTag(class c: String, text: String) -> String {
        return "<span class='\(c)'>" + escapeHtmlSpecialCharacters(text) + "</span>"
    }

    private func replaceSymbols(text: String) -> String {
        return text.replacingOccurrences(of: "&nbsp;", with: "␣").replacingOccurrences(of: "<br>", with: "<br>↲")
    }

    private func processComment(text: String) {
        let comments = text.split(separator: "\n", omittingEmptySubsequences: false)
        row += comments.count - 1
        column += comments.last!.count
    }

    private func escapeHtmlSpecialCharacters(_ string: String) -> String {
        var newString = string
        let specialCharacters = [
            "&": "&amp;",
            "<": "&lt;",
            ">": "&gt;",
            "\"": "&quot;",
            "'": "&apos;"
        ];
        for (escaped, unescaped) in specialCharacters {
            newString = newString.replacingOccurrences(of: escaped, with: unescaped, options: .literal, range: nil)
        }
        return newString
    }
}