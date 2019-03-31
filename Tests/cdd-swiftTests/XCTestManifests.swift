import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(cdd_swiftTests.allTests),
    ]
}
#endif
