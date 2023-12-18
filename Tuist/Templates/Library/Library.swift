import ProjectDescription

let nameAttribute: Template.Attribute = .required("name")

let template = Template(
    description: "Library template",
    attributes: [
        nameAttribute,
    ],
    items: [
        .file(
            path: "\(nameAttribute)/Project.swift",
            templatePath: "LibraryProject.stencil"
        ),
        .file(
            path: "\(nameAttribute)/Sources/\(nameAttribute).swift",
            templatePath: "LibrarySource.stencil"
        ),
        .file(
            path: "\(nameAttribute)/Tests/\(nameAttribute)Tests.swift",
            templatePath: "LibraryTests.stencil"
        )
    ]
)
