import MetalKit

final class MetalImageView: CoreImageView {

  private let drawer: Drawer
  private let mtlView: MTKView

  override var image: CIImage? {
    set {
      drawer.image = newValue
    }
    get {
      return drawer.image
    }
  }

  override init(frame: CGRect) {
    guard let device = MTLCreateSystemDefaultDevice() else {
      fatalError("Device doesn't support Metal")
    }
    drawer = Drawer(device: device)
    mtlView = MTKView(frame: CGRect(origin: CGPoint.zero, size: frame.size), device: device)
    mtlView.framebufferOnly = false
    mtlView.delegate = drawer
    super.init(frame: frame)
    setupSubview()
  }

  @available(*, unavailable)
  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupSubview() {
    assert(mtlView.superview == nil, "Subview already set up")
    addSubview(mtlView)
    mtlView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate(
      [
        topAnchor.constraint(equalTo: mtlView.topAnchor),
        bottomAnchor.constraint(equalTo: mtlView.bottomAnchor),
        leadingAnchor.constraint(equalTo: mtlView.leadingAnchor),
        trailingAnchor.constraint(equalTo: mtlView.trailingAnchor)
      ]
    )
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    mtlView.setNeedsDisplay()
  }
}

extension MetalImageView {

  static var isAvailable: Bool {
    // TODO: better use device type for this
    return MTLCreateSystemDefaultDevice() != nil
  }
}

private final class Drawer: NSObject, MTKViewDelegate {

  var image: CIImage? {
    didSet {
      updateScaledImage()
    }
  }
  private var scaledImage: CIImage?

  private let ciContext: CIContext
  private let commandQueue: MTLCommandQueue
  private let colorSpace: CGColorSpace

  private var drawableSize: CGSize {
    didSet {
      updateScaledImage()
    }
  }

  init(device: MTLDevice) {
    ciContext = CIContext(mtlDevice: device)
    commandQueue = device.makeCommandQueue()
    colorSpace = CGColorSpaceCreateDeviceRGB()
    drawableSize = CGSize.zero
  }

  private func updateScaledImage() {
    if let image = image {
      scaledImage = scale(image: image)
    } else {
      scaledImage = nil
    }
  }

  func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
    drawableSize = size
    view.setNeedsDisplay()
  }

  func draw(in view: MTKView) {
    guard let currentDrawable = view.currentDrawable, let image = scaledImage else { return }
    let commandBuffer = commandQueue.makeCommandBuffer()
    ciContext.render(
      image,
      to: currentDrawable.texture,
      commandBuffer: commandBuffer,
      bounds: CGRect(origin: CGPoint.zero, size: drawableSize),
      colorSpace: colorSpace
    )
    commandBuffer.present(currentDrawable)
    commandBuffer.commit()
  }

  private func scale(image: CIImage) -> CIImage {
    let scale = min(drawableSize.width / image.extent.width, drawableSize.height / image.extent.height)
    let origin = CGPoint(
      x: (drawableSize.width - image.extent.size.width * scale) / 2,
      y: (drawableSize.height - image.extent.size.height * scale) / 2
    )
    return image
      .applying(CGAffineTransform(scaleX: scale, y: scale))
      .applying(CGAffineTransform(translationX: origin.x, y: origin.y))
  }
}
