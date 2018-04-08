import CoreImage

final class Crop: ImageApplyingFilter {

  let name = "CICrop"

  var input: CIImage?

  var rect: CGRect

  var inputParameters: [String : Any] {
    return [
      "inputRectangle": vectorizedRect
    ]
  }

  init(input: CIImage? = nil, rect: CGRect) {
    self.input = input
    self.rect = rect
  }

  private var vectorizedRect: CIVector {
    return CIVector(
      x: rect.origin.x,
      y: rect.origin.y,
      z: rect.size.width,
      w: rect.size.height
    )
  }
}
