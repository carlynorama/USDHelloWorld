from pxr import Usd, UsdGeom
import sys

def main(output):
    stage = Usd.Stage.CreateNew(output)
    xformPrim = UsdGeom.Xform.Define(stage, '/hello')
    spherePrim = UsdGeom.Sphere.Define(stage, '/hello/world')
    stage.GetRootLayer().Save()

if __name__ == "__main__":
    main(sys.argv[1])
