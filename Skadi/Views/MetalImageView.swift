// Because Metal is not available in iPhone Simulator
#if arch(arm) || arch(arm64)

  import MetalKit

  final class MetalImageView: UIView, CoreImageView {

    private let drawer: Drawer
    private let mtlView: MTKView

    var image: CIImage? {
      set {
        drawer.image = newValue
        mtlView.setNeedsDisplay()
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
      mtlView = MTKView(
        frame: CGRect(origin: CGPoint.zero, size: frame.size),
        device: device
      )
      mtlView.framebufferOnly = false
      mtlView.isPaused = true
      mtlView.enableSetNeedsDisplay = true
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
      if let commandQueue = device.makeCommandQueue() {
        self.commandQueue = commandQueue
      } else {
        fatalError("Cannot create command queue!")
      }
      colorSpace = CGColorSpaceCreateDeviceRGB()
      drawableSize = CGSize.zero
    }

    private func updateScaledImage() {
      scaledImage = image.map(scale(image:)).map(center(image:))
    }

    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
      drawableSize = size
      view.setNeedsDisplay()
    }

    func draw(in view: MTKView) {
      guard
        let currentDrawable = view.currentDrawable,
        let image = scaledImage
      else { return }
      let commandBuffer = commandQueue.makeCommandBuffer()
      ciContext.render(
        image,
        to: currentDrawable.texture,
        commandBuffer: commandBuffer,
        bounds: CGRect(origin: CGPoint.zero, size: drawableSize),
        colorSpace: colorSpace
      )
      commandBuffer?.present(currentDrawable)
      commandBuffer?.commit()
    }

    // MARK: Image Helpers

    private func scale(image: CIImage) -> CIImage {
      let scale = min(
        drawableSize.width / image.extent.width,
        drawableSize.height / image.extent.height
      )
      return image.transformed(by: CGAffineTransform(scaleX: scale, y: scale))
    }

    private func center(image: CIImage) -> CIImage {
      let horizontalMargin = (drawableSize.width - image.extent.size.width) / 2
      let verticalMargin = (drawableSize.height - image.extent.size.height) / 2
      return image.transformed(
        by: CGAffineTransform(
          translationX: horizontalMargin + abs(image.extent.origin.x),
          y: verticalMargin + abs(image.extent.origin.y)
        )
      )
    }
  }
  
#endif
