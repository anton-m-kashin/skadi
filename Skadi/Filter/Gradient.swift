import CoreImage
import UIKit.UIColor

final class Gradient: Filter {

  let name: String = "CILinearGradient"

  var inputParameters: [String : Any] {
    let keys = ["inputColor0", "inputColor1", "inputPoint0", "inputPoint1"]
    let value = [
      CIColor(color: startColor),
      CIColor(color: endColor),
      startPoint.map(CIVector.init(cgPoint:)),
      endPoint.map(CIVector.init(cgPoint:))
    ]
    .compactMap({ $0 })
    return Dictionary(uniqueKeysWithValues: zip(keys, value))
  }

  var startColor: UIColor
  var endColor: UIColor

  var startPoint: CGPoint?
  var endPoint: CGPoint?

  init(
    startColor: UIColor,
    endColor: UIColor,
    startPoint: CGPoint? = nil,
    endPoint: CGPoint? = nil
  ) {
    self.startColor = startColor
    self.endColor = endColor
    self.startPoint = startPoint
    self.endPoint = endPoint
  }
}
