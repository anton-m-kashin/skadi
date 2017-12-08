import GLKit

final class GLImageView: UIView, CoreImageView {

  private let drawer: Drawer
  private let glView: GLKView

  var image: CIImage? {
    set {
      drawer.image = newValue
      glView.setNeedsDisplay()
    }
    get {
      return drawer.image
    }
  }

  override init(frame: CGRect) {
    let glContext: EAGLContext = {
      guard
        let glContext = EAGLContext.makeContextWithHigherAvailableAPI()
      else { fatalError("Device doesn't support OpenGLES") }
      return glContext
    } ()
    drawer = Drawer(glContext: glContext)
    glView = GLKView(
      frame: CGRect(origin: CGPoint.zero, size: frame.size),
      context: glContext
    )
    glView.delegate = drawer
    super.init(frame: frame)
    setupSubview()
  }

  @available(*, unavailable)
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupSubview() {
    assert(glView.superview == nil, "Subview already set up")
    addSubview(glView)
    glView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate(
      [
        topAnchor.constraint(equalTo: glView.topAnchor),
        bottomAnchor.constraint(equalTo: glView.bottomAnchor),
        leadingAnchor.constraint(equalTo: glView.leadingAnchor),
        trailingAnchor.constraint(equalTo: glView.trailingAnchor)
      ]
    )
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    glView.setNeedsDisplay()
  }
}

private final class Drawer: NSObject, GLKViewDelegate {

  var image: CIImage?
  private let ciContext: CIContext

  init(glContext: EAGLContext) {
    ciContext = CIContext(
      eaglContext: glContext,
      options: [kCIContextWorkingColorSpace: NSNull()]
    )
  }

  public func glkView(_ view: GLKView, drawIn rect: CGRect) {
    guard let image = image else { return }
    ciContext.draw(
      image,
      in: image.extent.aspectFit(in: CGRect(
        origin: CGPoint.zero,
        size: CGSize(width: view.drawableWidth, height: view.drawableHeight)
        )
      ),
      from: image.extent
    )
  }
}
