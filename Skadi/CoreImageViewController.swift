import UIKit

final class CoreImageViewController: UIViewController {

  // MARK: Public Properties

  var image: CIImage? {
    didSet {
      if !isViewLoaded { return }
      imageView.image = image
    }
  }

  // MARK: Subviews

  typealias ImageView = UIView & CoreImageView

  private let imageView: ImageView = {
    #if arch(arm) || arch(arm64)
      if MetalImageView.isAvailable {
        return MetalImageView(frame: CGRect.zero)
      } else {
        return GLImageView(frame: CGRect.zero)
      }
    #else
      return GLImageView(frame: .zero)
    #endif
  }()

  // MARK: Lifecycle

  init(image: CIImage?) {
    self.image = image
    super.init(nibName: nil, bundle: nil)
  }

  @available (*, unavailable)
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: View Lifecycle

  override func loadView() {
    super.loadView()
    setupSubviews()
    setupLayout()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    imageView.image = image
  }

  // MARK: Initialization Helpers

  private func setupSubviews() {
    assert(view.subviews.isEmpty)
    view.addSubview(imageView)
  }

  private func setupLayout() {
    assert(view.constraints.isEmpty)
    imageView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate(
      [
        view.topAnchor.constraint(equalTo: imageView.topAnchor),
        view.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
        view.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
        view.trailingAnchor.constraint(equalTo: imageView.trailingAnchor)
      ]
    )
  }
}
