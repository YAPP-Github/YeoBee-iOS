import ProjectDescription

let featureNameAttribute: Template.Attribute = .required("name")

let featureTemplate = Template(
    description: "Feature template",
    attributes: [
        featureNameAttribute,
    ],
    items: [
        .file(
            path: "\(nameAttribute)/Project.swift",
            templatePath: "FeatureProject.stencil"
        ),
        .file(
            path: "\(nameAttribute)/Sources/\(nameAttribute).swift",
            templatePath: "FeatureSource.stencil"
        ),
        .file(
            path: "\(nameAttribute)/Tests/\(nameAttribute)Tests.swift",
            templatePath: "FeatureTests.stencil"
        ),
        .file(
            path: "\(nameAttribute)/DemoApp/Sources/AppDelegate.swift",
            templatePath: "AppDelegate.stencil"
        )
        
    ]
)
