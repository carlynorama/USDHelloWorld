# USDServiceProvider

Initial proof of concept for using OpenUSD Library in a MacOS or Linux project written in Swift.

This Library expects the programmer to have a known-good build of OpenUSD, using one of the following: 

- system's default build of python
- a pyenv managed version of python
- a version of python at `/Library/Frameworks/Python.framework/Versions/\(version)/bin`
- a version of python at some other programmer known location. 

Not many functions working yet but usdacat and usdchecker can be run and return values.


## Example Usage

See: https://github.com/carlynorama/USDTestingCLI

This CLI has an easier time of it running via "swift run myusdtests" rather than Xcode run button due to python sandboxing and path complexities. It still can works, just a bit more fiddly.

A CLI Client Main File

```swift
import Foundation
import ArgumentParser
import USDServiceProvider

//MARK: --------------------- YOUR SETUP GOES HERE ------------------------
let USDBuild = "/Users/carlynorama/opd/USD_nousdview_py3_10_0723/"
let pythonEnv:USDServiceProvider.PythonEnvironment = .pyenv("3.10")

@main
public struct USDTestingCLI:ParsableCommand {
    public static let configuration = CommandConfiguration(
        
        abstract: "A Swift command-line tool",
        version: "0.0.1",
        subcommands: [
            testusdcat.self,
            checkncrate.self,
            helloworld.self
        ],
        defaultSubcommand: helloworld.self)
    
    public init() {}
    
    struct testusdcat:ParsableCommand {
        func run() throws {
            print(USDServiceProvider(pathToUSDBuild:USDBuild, pythonEnv: pythonEnv).usdcatHelp())
        }
    }
    
    struct checkncrate:ParsableCommand {
        
        @Argument(help: "The input file") var inputFile: String
        @Argument(help: "The output file") var outputFile: String?
        
        func run() throws {
            
            //TODO: fragile. if cli sticks around, improve.
            let outputFilePath = outputFile ?? inputFile.replacingOccurrences(of: ".usda", with: ".usdc")
            
            let usdSP = USDServiceProvider(pathToUSDBuild: USDBuild, pythonEnv: pythonEnv)
            
            print("hello")
            
            let reuslt = usdSP.check(inputFile)
            print(reuslt)
            usdSP.makeCrate(from: inputFile, outputFile: outputFilePath)
        }
    }
    
    struct helloworld:ParsableCommand {
        @Argument(help: "The output file") var outputFile: String?
        
        func run() throws {
            
            //TODO: also fragile. if cli sticks around, improve.
            let outputFilePath = outputFile ?? "~/Documents/hello_world.usda"
            
            let usdSP = USDServiceProvider(pathToUSDBuild: USDBuild, pythonEnv: pythonEnv)
            usdSP.saveHelloWorld(to: outputFilePath)
        }
    }
    
    
}

```

Package file using as a local library

```
// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.



import PackageDescription

let package = Package(
    name: "USDTestingCLI",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .executable(
            name: "myusdtests",
            targets: ["USDTestingCLI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.2.2"),
        .package(path: "../USDServiceProvider"),
    ],
    targets: [
        .executableTarget(
            name: "USDTestingCLI",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "USDServiceProvider", package: "USDServiceProvider"),
            ]),
        .testTarget(
            name: "USDTestingCLITests",
            dependencies: ["USDTestingCLI"]),
    ]
)

```
