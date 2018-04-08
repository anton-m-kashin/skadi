import CoreImage
import UIKit.UIColor

final class ColorMap: ImageApplyingFilter {

  let name: String = "CIColorMap"

  var input: CIImage?

  var inputParameters: [String : Any] {
    return ["inputGradientImage": overlayImage]
  }

  var overlayImage: CIImage

  init(input: CIImage? = nil, overlayImage: CIImage) {
    self.input = input
    self.overlayImage = overlayImage
  }

  convenience init(
    input: CIImage? = nil,
    gradient: GradientParameters
  ) {
    guard let gradientImage = Skadi.Gradient(gradient).output else {
      fatalError()
    }
    self.init(
      input: input,
      overlayImage: gradientImage
        .cropped(to: CGRect(
          origin: .zero,
          size: CGSize(width: gradient.size, height: 1)
        )
      )
    )
  }
}

extension ColorMap {

  struct GradientParameters {

    var start: UIColor
    var end: UIColor
    var size: CGFloat

    init(start: UIColor, end: UIColor, size: CGFloat = 100) {
      self.start = start; self.end = end; self.size = size
    }

    static var blueMagenta = GradientParameters(start: .blue, end: .magenta)
    static var greenCyan = GradientParameters(start: .green, end: .cyan)
    static var redYellow = GradientParameters(start: .red, end: .yellow)
  }
}

private extension Gradient {

  convenience init(_ gradient: ColorMap.GradientParameters) {
    self.init(
      startColor: gradient.start,
      endColor: gradient.end,
      startPoint: .zero,
      endPoint: CGPoint(x: gradient.size, y: 0)
    )
  }
}
