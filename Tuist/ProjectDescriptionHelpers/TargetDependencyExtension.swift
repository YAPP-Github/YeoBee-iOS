import ProjectDescription

// MARK: Project
public extension TargetDependency {
    static let yeoBee: TargetDependency = .project(
        target: "YeoBee",
        path: .relativeToRoot("Projects/YeoBee"))
    static let designSystem: TargetDependency = .project(
        target: "DesignSystem",
        path: .relativeToRoot("Projects/DesignSystem"))
    static let ybnetwork: TargetDependency = .project(
        target: "YBNetwork",
        path: .relativeToRoot("Projects/YBNetwork"))
    static let entity: TargetDependency = .project(
        target: "Entity",
        path: .relativeToRoot("Projects/Entity"))
    static let sign: TargetDependency = .project(
        target: "Sign",
        path: .relativeToRoot("Projects/Features/Sign"))
    static let expenditure: TargetDependency = .project(
        target: "Expenditure",
        path: .relativeToRoot("Projects/Features/Expenditure"))
    static let home: TargetDependency = .project(
        target: "Home",
        path: .relativeToRoot("Projects/Features/Home"))
    static let travelRegistration: TargetDependency = .project(
        target: "TravelRegistration",
        path: .relativeToRoot("Projects/Features/TravelRegistration"))
    static let travleEdit: TargetDependency = .project(
        target: "TravelEdit",
        path: .relativeToRoot("Projects/Features/TravelEdit"))
    static let onboarding: TargetDependency = .project(
        target: "Onboarding",
        path: .relativeToRoot("Projects/Features/Onboarding"))
    static let expenditureEdit: TargetDependency = .project(
        target: "ExpenditureEdit",
        path: .relativeToRoot("Projects/Features/ExpenditureEdit"))
    static let coordinator: TargetDependency = .project(
        target: "Coordinator",
        path: .relativeToRoot("Projects/Coordinator"))
    static let trip: TargetDependency = .project(
        target: "Trip",
        path: .relativeToRoot("Projects/Features/Trip"))
    static let usecase: TargetDependency = .project(
        target: "UseCase",
        path: .relativeToRoot("Projects/UseCase"))
    static let repository: TargetDependency = .project(
        target: "Repository",
        path: .relativeToRoot("Projects/Repository"))
    static let ybdependency: TargetDependency = .project(
        target: "YBDependency",
        path: .relativeToRoot("Projects/YBDependency"))
}

// MARK: Package
public extension TargetDependency {
    static let RxSwift: TargetDependency = .external(name: "RxSwift")
    static let RxGesture: TargetDependency = .external(name: "RxGesture")
    static let RxCocoa: TargetDependency = .external(name: "RxCocoa")
    static let moya: TargetDependency = .external(name: "Moya")
    static let reactorKit: TargetDependency = .external(name: "ReactorKit")
    static let SnapKit: TargetDependency = .external(name: "SnapKit")
    static let fscalendar: TargetDependency = .external(name: "FSCalendar")
    static let composableArchitecture: TargetDependency = .external(name: "ComposableArchitecture")
}

public extension Package {
    static let RxSwift = Package.remote(url: "https://github.com/ReactiveX/RxSwift", requirement: .upToNextMajor(from: "6.2.0"))
    static let RxGesture = Package.remote(url: "https://github.com/RxSwiftCommunity/RxGesture.git", requirement: .upToNextMajor(from: "4.0.3"))
    static let moya: Package = .remote(url: "https://github.com/Moya/Moya.git", requirement: .branch("master"))
    static let reactorKit: Package = .remote(url: "https://github.com/ReactorKit/ReactorKit.git", requirement: .branch("master"))
    static let SnapKit: Package = .remote(url: "https://github.com/SnapKit/SnapKit.git", requirement: .upToNextMajor(from: "5.0.1"))
    static let fscalendar: Package = .remote(url: "https://github.com/WenchaoD/FSCalendar.git", requirement: .branch("master"))
    static let composableArchitecture: Package = .remote(url: "https://github.com/pointfreeco/swift-composable-architecture", requirement: .exact("1.0.0"))
}

// MARK: SourceFile
public extension SourceFilesList {
    static let sources: SourceFilesList = "Sources/**"
    static let demoSources: SourceFilesList = "DemoApp/Sources/**"
    static let tests: SourceFilesList = "Tests/**"
}
