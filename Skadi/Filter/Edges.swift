import CoreImage

final class Edges: ImageApplyingFilter {

  let name = "CIEdges"

  var input: CIImage?

  var intensity: Float

  var inputParameters: [String : Any] {
    return ["inputIntensity": intensity]
  }

  init(input: CIImage? = nil, intensity: Float = 1.0) {
    self.input = input
    self.intensity = intensity
  }
}
