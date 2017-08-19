import UIKit

class ViewController<ImageView: CoreImageView>: UIViewController where ImageView: UIView {

  private let imageView: ImageView

  init(imageView: ImageView) {
    self.imageView = imageView
    super.init(nibName: nil, bundle: nil)
  }

  @available (*, unavailable)
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

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
