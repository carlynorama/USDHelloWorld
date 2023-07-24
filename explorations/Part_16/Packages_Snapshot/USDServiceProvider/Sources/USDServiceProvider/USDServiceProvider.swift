import Foundation

public struct USDServiceProvider:USDService {
    
    public private(set) var pathToBaseDir:String
    public private(set) var pythonEnv:PythonEnvironment
    
    
    public init(pathToUSDBuild:String, pythonEnv:PythonEnvironment) {
        self.pathToBaseDir = pathToUSDBuild
        self.pythonEnv = pythonEnv
    }
    
    var pathToBin:String {
        "\(pathToBaseDir)/bin"
    }
    
    var pathToPython:String {
        "\(pathToBaseDir)/lib/python"
    }
    
    public func usdcatHelp() -> String {
        //TODO: Environment setting means don't need full path.
        let message = try? shell("\(pathToBin)/usdcat -h")
        return (message != nil) ? message! : "nothing to say"
    }
    
    @discardableResult
    public func makeCrate(from inputFile:String, outputFile:String) -> String {
       // print(try? shell("pwd"))
        let message = try? shell("usdcat -o \(outputFile) --flatten \(inputFile)")
        return message ?? ""
    }
    
    public func check(_ inputFile:String) -> String {
       // print(try? shell("pwd"))
        let message = try? shell("usdchecker \(inputFile)")
        return message ?? "no message"
    }
    
    
    // Works from Terminal other shell program, not so much XCode b/c of pyenv
    // TODO: Try on computer with system python USD Build
    public func saveHelloWorld(to outputLocation:String) {
        let current = URL(string: #file)
        let dir = current!.deletingLastPathComponent()
        let message = try? shell("python3 \(dir)/python_scripts/hello_world.py \(outputLocation)")
        print("message:\(message ?? "no message")")
    }
    
    @discardableResult
    func shell(_ command: String) throws -> String {
        let task = Process()
        let pipe = Pipe()
        
        task.standardOutput = pipe
        task.standardError = pipe
        task.arguments = ["-c", environmentWrap(command, python: pythonEnv)]
        
        task.standardInput = nil
        task.executableURL = URL(fileURLWithPath: "/bin/bash") //<-- what shell
        
        //The technically correct way to pass in environment vars.
        //Does work.
        //var environment =  ProcessInfo.processInfo.environment
        //environment["PYTHONPATH"] = "\(pathToPython)"
        //task.environment = environment
        //print(task.environment ?? "")
        
        try task.run()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)!
        
        return output
    }
}

extension USDServiceProvider {
    
    func environmentWrap(_ newCommand:String, python:PythonEnvironment) -> String {
        """
        \(python.setString)
        export PATH=$PATH:\(pathToBaseDir)/bin;
        export PYTHONPATH=$PYTHONPATH:\(pathToBaseDir)/lib/python
        \(newCommand)
        """
    }
    
    public enum PythonEnvironment {
        case defaultSystem
        case pyenv(String)
        case systemInstallMacOS(String)
        case customPath(String)
        
        var setString:String {
            switch self {
                
            case .defaultSystem:
                return ""
            case .pyenv(let v):
                return setPythonWithPyEnv(version: v)
            case .systemInstallMacOS(let v):
                return setPythonSystemMacOS(version: v)
            case .customPath(let p):
                return prependPath(customString: p)
            }
        }
        
        func setPythonWithPyEnv(version:String) -> String {
            """
            export PYENV_ROOT="$HOME/.pyenv"
            command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
            eval "$(pyenv init -)"
            export PYENV_VERSION=\(version)
            """
        }
        
        func setPythonSystemMacOS(version:String) -> String {
            """
            PATH="/Library/Frameworks/Python.framework/Versions/\(version)/bin:${PATH}"
            export PATH
            """
        }
        
        func prependPath(customString:String) -> String {
            """
            PATH="\(customString):${PATH}"
            export PATH
            """
        }
    }

}
