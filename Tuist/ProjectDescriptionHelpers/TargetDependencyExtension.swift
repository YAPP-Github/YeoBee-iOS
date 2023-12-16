import ProjectDescription

// MARK: Project
public extension TargetDependency {
    static let yeoBee: TargetDependency = .project(
        target: "YeoBee",
        path: .relativeToRoot("Projects/YeoBee"))
    static let designSystem: TargetDependency = .project(
        target: "DesignSystem",
        path: .relativeToRoot("Projects/DesignSystem"))
    static let network: TargetDependency = .project(
        target: "Network",
        path: .relativeToRoot("Projects/Network"))
    static let sign: TargetDependency = .project(
        target: "Sign",
        path: .relativeToRoot("Projects/Features/Sign"))
    static let expenditure: TargetDependency = .project(
        target: "Expenditure",
        path: .relativeToRoot("Projects/Features/Expenditure"))
}

// MARK: Package
public extension TargetDependency {
    static let moya: TargetDependency = .package(product: "Moya")
    static let reactorKit: TargetDependency = .package(product: "ReactorKit")
    static let flexLayout: TargetDependency = .package(product: "FlexLayout")
    static let pinLayout: TargetDependency = .package(product: "PinLayout")
}

public extension Package {
    static let moya: Package = .package(url: "https://github.com/Moya/Moya", .branch("master"))
    static let reactorKit: Package = .package(url: "https://github.com/ReactorKit/ReactorKit.git", .branch("master"))
    static let flexLayout: Package = .package(url: "https://github.com/layoutBox/FlexLayout.git", .branch("master"))
    static let pinLayout: Package = .package(url: "https://github.com/layoutBox/PinLayout.git", .branch("master"))
}

// MARK: SourceFile
public extension SourceFilesList {
    static let sources: SourceFilesList = "Sources/**"
    static let demoSources: SourceFilesList = "DemoApp/Sources/**"
    static let tests: SourceFilesList = "Tests/**"
}
