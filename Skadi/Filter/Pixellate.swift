import CoreImage

final class Pixellate: ImageApplyingFilter {

  let name = "CIPixellate"

  var input: CIImage?

  var center: CGPoint
  var scale: Float

  var inputParameters: [String : Any] {
    return [
      "inputCenter": vectorizedCenter,
      "inputScale": scale
    ]
  }

  private var vectorizedCenter: CIVector {
    return CIVector(x: center.x, y: center.y)
  }

  init(input: CIImage? = nil, center: CGPoint = CGPoint(x: 150, y: 150), scale: Float = 8.0) {
    self.input = input
    self.center = center
    self.scale = scale
  }
}
