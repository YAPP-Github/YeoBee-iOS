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
    static let home: TargetDependency = .project(
        target: "Home",
        path: .relativeToRoot("Projects/Features/Home"))
    static let travleEdit: TargetDependency = .project(
        target: "TravelEdit",
        path: .relativeToRoot("Projects/Features/TravelEdit"))
    static let onboarding: TargetDependency = .project(
        target: "Onboarding",
        path: .relativeToRoot("Projects/Features/Onboarding"))
}

// MARK: Package
public extension TargetDependency {
    static let RxSwift: TargetDependency = .external(name: "RxSwift")
    static let RxCocoa: TargetDependency = .external(name: "RxCocoa")
    static let moya: TargetDependency = .external(name: "Moya")
    static let reactorKit: TargetDependency = .external(name: "ReactorKit")
    static let flexLayout: TargetDependency = .external(name: "FlexLayout")
    static let pinLayout: TargetDependency = .external(name: "PinLayout")
    static let fscalendar: TargetDependency = .external(name: "FSCalendar")
}

public extension Package {
    static let RxSwift = Package.remote(url: "https://github.com/ReactiveX/RxSwift", requirement: .upToNextMajor(from: "6.2.0"))
    static let moya: Package = .remote(url: "https://github.com/Moya/Moya.git", requirement: .branch("master"))
    static let reactorKit: Package = .remote(url: "https://github.com/ReactorKit/ReactorKit.git", requirement: .branch("master"))
    static let flexLayout: Package = .remote(url: "https://github.com/layoutBox/FlexLayout.git", requirement: .branch("master"))
    static let pinLayout: Package = .remote(url: "https://github.com/layoutBox/PinLayout.git", requirement: .branch("master"))
    static let fscalendar: Package = .remote(url: "https://github.com/WenchaoD/FSCalendar.git", requirement: .branch("master"))
}

// MARK: SourceFile
public extension SourceFilesList {
    static let sources: SourceFilesList = "Sources/**"
    static let demoSources: SourceFilesList = "DemoApp/Sources/**"
    static let tests: SourceFilesList = "Tests/**"
}
