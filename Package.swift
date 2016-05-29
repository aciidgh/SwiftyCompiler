import PackageDescription

let package = Package(
    name: "SwiftyCompiler",
    dependencies: [.Package(url: "../CLLVM", majorVersion: 1),]
)
