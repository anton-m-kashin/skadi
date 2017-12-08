import CoreGraphics

extension CGRect {

  func aspectFit(in rect: CGRect) -> CGRect {
    let scale: CGFloat = min(rect.width / self.width, rect.height / self.height)
    let width = self.width * scale
    let height = self.height * scale
    let x = rect.midX - width / 2
    let y = rect.midY - height / 2
    return CGRect(x: x, y: y, width: width, height: height)
  }
}
