import CoreImage

final class Bloom: Filter {

  let name = "CIBloom"

  var input: CIImage?

  var output: CIImage? {
    guard let input = input else { return nil }
    let bloomed = input.applyingFilter(name, withInputParameters: inputParameters)
    if !cropToOriginalSize { return bloomed }
    return Crop(input: bloomed, rect: input.extent).output
  }

  var radius: Float
  var intensity: Float

  var cropToOriginalSize: Bool

  var inputParameters: [String : Any]? {
    return [
      "inputRadius": radius,
      "inputIntensity": intensity
    ]
  }

  init(input: CIImage? = nil,
       radius: Float = 10.0,
       intensity: Float = 0.5,
       cropToOriginalSize: Bool = false)
  {
    self.input = input
    self.radius = radius
    self.intensity = intensity
    self.cropToOriginalSize = cropToOriginalSize
  }
}
