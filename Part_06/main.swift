let minX = -4.0
let maxX = 4.0
let minY = minX
let maxY = maxX
let minZ = minX
let maxZ = maxX
let minRadius = 0.8
let maxRadius = 2.0

import Foundation

// @StringBuilder func testStringBuilder(_ count:Int) -> String {
//     for i in (0...count).reversed() {
//         "\(i)…"
//     }
//     "String Made!"
// }

@StringBuilder func  makeMultiBall(count:Int) -> String {
    let builder = USDAFileBuilder()
    builder.generateHeader(defaultPrim:"blueSphere")
    builder.buildItem("blueSphere", "sphere_base", "sphere", 0, 0, 0, 1, 0, 0, 1)

    for i in (0...count) {
        builder.buildItem(
            "sphere_\(i)", 
            "sphere_base", 
            "sphere", 
            Double.random(in: minX...maxX), 
            Double.random(in: minY...maxY), 
            Double.random(in: minZ...maxZ), 
            Double.random(in: minRadius...maxRadius), 
            Double.random(in: 0...1), 
            Double.random(in: 0...1), 
            Double.random(in: 0...1)
        )
    }
}

print("Hello!")

/// the very first element is the current script
let script = CommandLine.arguments[0]
print("Script:", script)

/// you can get the input arguments by dropping the first element
let inputArgs = CommandLine.arguments.dropFirst()
print("Number of arguments:", inputArgs.count)

var count:Int = 12
var fileName:String = "multiball.usda"

switch (inputArgs.count) {
    case 1:
        guard let tmp_count = Int(inputArgs[0]) else {
            fatalError("Argument is not a number so can't create a count")
        }
        count = tmp_count
    case 2: 
        guard let tmp_count = Int(inputArgs[0]) else {
            fatalError("Argument is not a number so can't create a count")
        }
        fileName = inputArgs[1]
        count = tmp_count
    default:
        print("Undecipherable number of arguments. Using defaults.")
}

print("\(count), \(fileName)")
let usdFileText = makeMultiBall(count: count)
let fileURL = URL(filePath: fileName)

do {
    try usdFileText.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
} catch { 
    print(error)
}


// /// reading lines from the standard input
// print("Please enter your input:")
// guard let input = readLine(strippingNewline: true) else {
//     fatalError("Missing input")
// }
// print(input)