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
