struct USDAFileBuilder {
let header = "#usda 1.0\n"
static func testPrint() {
    print("I see you.")
}

func translateString(_ xoffset:Double, _ yoffset:Double, _ zoffset:Double) -> String {
    return "\tdouble3 xformOp:translate = (\(xoffset), \(yoffset), \(zoffset))"
}

func opOrderStringTranslateOnly() -> String {
    "\tuniform token[] xformOpOrder = [\"xformOp:translate\"]"
}
    
func colorString(_ red:Double, _ green:Double, _ blue:Double) -> String {
    "\t\tcolor3f[] primvars:displayColor = [(\(red), \(green), \(blue))]"
}
    
func  radiusString(_ radius:Double) -> String {
     "\t\tdouble radius = \(radius)"
}

@StringBuilder func  buildItem(_ id:String, _ reference_file:String, _ geometry_name:String, _ xoffset:Double, _ yoffset:Double, _ zoffset:Double, _ radius:Double, _ red:Double, _ green:Double, _ blue:Double) -> String {
    """
    \nover "\(id)" (\n\tprepend references = @./\(reference_file).usd@\n)\n{
    """
    
    if xoffset != 0 || yoffset != 0 || zoffset != 0 {
        translateString(xoffset, yoffset, zoffset)
        opOrderStringTranslateOnly()
    }
               
    """
    \tover "\(geometry_name)"\n\t{
    """
    colorString(red, green, blue)
    radiusString(radius)
    "\t}"
    "}"
} 


 
}

