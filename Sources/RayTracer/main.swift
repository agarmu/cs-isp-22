import Foundation


let scene = Scene(
    width: 400,
    aspectRatio: 16/9,
    objects: [
        Sphere([0,0,-1], 0.5),
        Sphere([0,-100.5,-1], 100)
    ]
)
scene.scan()
scene.export()



