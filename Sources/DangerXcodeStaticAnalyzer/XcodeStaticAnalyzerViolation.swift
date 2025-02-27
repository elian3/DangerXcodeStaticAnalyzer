public struct XcodeStaticAnalyzerViolation: Codable {
    public let description: String
    public let location: Location

    public struct Location: Codable {
        public let line: Int
        public let column: Int
        public let file: String
    }
}

public struct XcodeStaticAnalyzerResult {
    public let violations: [XcodeStaticAnalyzerViolation]
    public let xcodeBuildResult: XcodeStaticAnalyzerBuildResult

    init(violations: [XcodeStaticAnalyzerViolation], result: Int32) {
        self.violations = violations
        xcodeBuildResult = result == Int32.zero ? .success : .error(XcodeStaticAnalyzerExecutionError.buildError(result))
    }
}

public enum XcodeStaticAnalyzerBuildResult {
    case success
    case error(XcodeStaticAnalyzerExecutionError)
}

public extension XcodeStaticAnalyzerBuildResult {
    var didSucceed: Bool {
        switch self {
        case .success:
            return true
        case .error(_):
            return false
        }
    }

    var didFail: Bool {
        return !didSucceed
    }

    var error: XcodeStaticAnalyzerExecutionError? {
        switch self {
        case .success:
            return nil
        case .error(let error):
            return error
        }
    }
}

public enum XcodeStaticAnalyzerExecutionError: Error {
    case buildError(Int32)
}

extension XcodeStaticAnalyzerExecutionError {
    public var localizedDescription: String {
        switch self {
        case .buildError(let result):
            return "Execution failed with exit code \(result)"
        }
    }
}
