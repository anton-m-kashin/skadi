import UIKit

class ViewController: UIViewController {

  private let imageView: CoreImageView = {
    if MetalImageView.isAvailable {
      return MetalImageView(frame: CGRect.zero)
    } else {
      return GLImageView(frame: CGRect.zero)
    }
  } ()

  override func loadView() {
    super.loadView()
    view.addSubview(imageView)
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

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    imageView.image = CIImage(image: #imageLiteral(resourceName: "Sailboat"))
  }
}
