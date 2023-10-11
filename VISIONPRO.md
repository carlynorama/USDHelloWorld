
# VisionPro

(file still a WIP)

## Requirements

- [XCode 15.8 BETA](https://developer.apple.com/services-account/download?path=/Developer_Tools/Xcode_15_beta_8/Xcode_15_beta_8.xip) (Oct 9, 2023)

## Examples of where can preview/use OpenUSD files now
   - FreeForm
   - Keynote "iWork"
   - Safari <model> tag
   - Quick Look
   - and of course Reality Composer Pro

## Relevant Frameworks

- [RealityKit](https://developer.apple.com/documentation/RealityKit)
    - [RealityView](https://developer.apple.com/documentation/RealityKit/RealityView)
- [SceneKit](https://developer.apple.com/documentation/scenekit)
- SpriteKit -> Used in KeyNote render
- [ARKit](https://developer.apple.com/documentation/ARKit)
- [ModelIO](https://developer.apple.com/documentation/modelio)


## Including USD Files

### Simple Import From Reality Composer Pro Package

From boiler plate of window.  

```swift
import SwiftUI
import RealityKit
import RealityKitContent //<- Arbitrary package name

struct ContentView: View {
    var body: some View {
        VStack {
            //bundle name defined in package 
            //e.g. in RealityKitContent.swift
            //public let realityKitContentBundle = Bundle.module
            Model3D(named: "Scene", bundle: realityKitContentBundle) 
                .padding(.bottom, 50)

            Text("Hello, world!")
        }
        .padding()
    }
}
```

There is a fancier caller available as seen at

https://developer.apple.com/wwdc23/10080?time=265

Note in this example the usdz file is in the main bundle, not in Reality Composer Pro package. 

```swift
struct GlobeModule: View {
    var body: some View {
        Model3D(named: "Globe") { model in
            model
                .resizable()
                .scaledToFit()
        } placeholder: {
          	ProgressView()
        }
    }
}
```

### RealityView Import (from RCP Bundle)

From boiler plate of Volume. 

```swift

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {

    @State var enlarge = false

    var body: some View {
        VStack {
            RealityView { content in
                // Add the initial RealityKit content
                if let scene = try? await Entity(named: "Scene", in: realityKitContentBundle) {
                    content.add(scene)
                }
            }
            //Update here refers to the update of the view, e.g. a change to the
            //@State variable enlarge.  
            update: { content in
                // Update the RealityKit content when SwiftUI state changes
                if let scene = content.entities.first {
                    let uniformScale: Float = enlarge ? 1.4 : 1.0
                    scene.transform.scale = [uniformScale, uniformScale, uniformScale]
                }
            }
            .gesture(TapGesture().targetedToAnyEntity().onEnded { _ in
                enlarge.toggle()
            })

            VStack {
                Toggle("Enlarge RealityView Content", isOn: $enlarge)
                    .toggleStyle(.button)
            }.padding().glassBackgroundEffect()
        }
    }
}
```

This code assumes that the USD file is annotated with an Input Target component and a Collision target. (from boiler plate code)

```usd
    def Sphere "Sphere" (
        active = true
        prepend apiSchemas = ["MaterialBindingAPI"]
    )
    {
        rel material:binding = </Root/_GridMaterial/GridMaterial> (
            bindMaterialAs = "weakerThanDescendants"
        )
        double radius = 0.05
        quatf xformOp:orient = (1, 0, 0, 0)
        float3 xformOp:scale = (1, 1, 1)
        float3 xformOp:translate = (0, 0, 0.0004)
        uniform token[] xformOpOrder = ["xformOp:translate", "xformOp:orient", "xformOp:scale"]

        def RealityKitComponent "Collider"
        {
            uint group = 1
            uniform token info:id = "RealityKit.Collider"
            uint mask = 4294967295
            token type = "Default"

            def RealityKitStruct "Shape"
            {
                float3 extent = (0.2, 0.2, 0.2)
                float radius = 0.05
                token shapeType = "Sphere"
            }
        }

        def RealityKitComponent "InputTarget"
        {
            uniform token info:id = "RealityKit.InputTarget"
        }
    }
```

This is easily accomplished via Reality Composer Pro UI, using the "Add Component Button" (Put model in Scene, add to instance in Scene seems to be the way.)

However, if you wanted to do so programatically, in theory one could use the following code instead, but I have found it temperamental getting it to work with USD files. (TODO: Adapt code from <https://developer.apple.com/forums/thread/119773>?) 

```swift
//based on https://developer.apple.com/forums/thread/734110
import SwiftUI
import RealityKit
import RealityKitContent

struct ImmersiveView: View {
    var body: some View {
        RealityView { content in
            
            let sphere = ModelEntity(mesh: .generateSphere(radius: 0.1))
            
            // A name for identifying this entity.
            sphere.name = "sphere"

            // Generates collision shapes for the sphere based on its geometry.
            sphere.generateCollisionShapes(recursive: false)
            
            // Give the sphere an InputTargetComponent.
            sphere.components.set(InputTargetComponent())
            
            // Set the initial position.
            sphere.position = .init(0, 2, -2)
            
            content.add(sphere)
        }
        .gesture(dragGesture)
    }
    
    var dragGesture: some Gesture {

        DragGesture()
            .targetedToAnyEntity()
            .onChanged { value in
                value.entity.position = value.convert(value.location3D, from: .local, to: value.entity.parent!)
                print(value.entity.name)
            }
    }
}
```


## Resources 

### Sample Code

- https://developer.apple.com/documentation/visionos/ 
- https://developer.apple.com/documentation/visionos/swift-splash 

### Misc Documentation

- https://developer.apple.com/documentation/realitykit/validating-usd-files
- https://developer.apple.com/documentation/realitykit/usdz-schemas-for-ar
- https://developer.apple.com/documentation/realitykit/placing-a-prim-in-the-real-world


### WWDC Videos

- Understand USD Fundamentals, WWDC22, https://developer.apple.com/videos/play/wwdc2022/10129/
- Create 3D workflows with USD, WWDC21
- Working with USD, WWDC 2109 <https://developer.apple.com/videos/play/wwdc2019/602/>
- Explore the USD ecosystem, WWDC23, <https://developer.apple.com/videos/play/wwdc2023/10086/>
    - 10:38 Custom Components RealityKit
- Build spatial experiences with RealityKit, WWDC23, <https://developer.apple.com/videos/play/wwdc2023/10080/>
- Explore materials in Reality Composer Pro, WWDC23, <https://developer.apple.com/videos/play/wwdc2023/10202/>
    -  <https://developer.apple.com/documentation/visionOS/diorama>


- Work with Reality Composer Pro content in Xcode 
- Meet Reality Composer Pro (inside .rkassets)
_ Explore Advanced Rendering with RealityKit 2

### Misc Helpful Answers on Forums

Last checked: Oct 2023

- https://stackoverflow.com/questions/60505755/realitykit-vs-scenekit-vs-metal-high-quality-rendering/60513052#60513052
- https://stackoverflow.com/questions/51059875/arkit-save-scene-as-usdz
- https://stackoverflow.com/questions/76823188/rotate-multiple-entities-independently-in-realityview
- 3 ways to rotate:
    - https://stackoverflow.com/questions/76719789/realitykit-entity-rotation-animation-doesnt-go-beyond-180-degree/76731764#76731764  
    - https://stackoverflow.com/questions/76796001/how-to-rotate-a-modelentity-in-visionos/76796954?noredirect=1#comment135425794_76796954
    - https://stackoverflow.com/questions/52893075/what-is-aranchor-exactly/52899502#52899502
- https://stackoverflow.com/questions/57593960/whats-the-difference-between-aranchor-and-anchorentity
- https://stackoverflow.com/questions/76747287/what-is-the-difference-between-model3d-and-realityview-in-visionos/76747520#76747520
- https://stackoverflow.com/questions/76569617/in-realitykit-how-can-i-get-programmatic-access-to-a-component-created-in-reali
- https://stackoverflow.com/questions/76616628/visionos-how-can-i-detect-when-two-entities-collide-in-realitykit
- https://developer.apple.com/forums/thread/738088 (Animations)