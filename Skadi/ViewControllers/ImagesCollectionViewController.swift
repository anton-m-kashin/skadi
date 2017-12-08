import UIKit

class ImagesCollectionViewController: UIViewController {

  // MARK: Public Properties

  var images: [CIImage]

  // MARK: Subviews

  private var collectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewFlowLayout()
  )

  // MARK: Lifecycle

  init(images: [CIImage] = []) {
    self.images = images
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

  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.reloadData()
  }

  // MARK: Initialization Helpers

  private func setupSubviews() {
    view.addSubview(collectionView)
    configureCollectionView()
  }

  private func setupLayout() {
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.pinToSuperviewBorders()
  }

  // MARK: Configuration

  private func configureCollectionView() {
    collectionView.register(
      UICollectionViewCell.self,
      forCellWithReuseIdentifier: "Cell"
    )
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.isPagingEnabled = true
    let layout = collectionView.collectionViewLayout
      as! UICollectionViewFlowLayout
    layout.scrollDirection = .horizontal
    layout.minimumLineSpacing = 0
    layout.minimumInteritemSpacing = 0
  }

  // MARK: Internals

  private var coreImageViewControllers: [IndexPath: CoreImageViewController]
    = [:]

  private func coreImageViewController(for indexPath: IndexPath)
  -> CoreImageViewController {
    let image = images[indexPath.item]
    if let viewController = coreImageViewControllers[indexPath] {
      viewController.image = image
      return viewController
    }
    let viewController = CoreImageViewController(image: image)
    coreImageViewControllers[indexPath] = viewController
    return viewController
  }
}

extension ImagesCollectionViewController: UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout {

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    return view.bounds.size
  }

  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return images.count
  }

  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: "Cell",
      for: indexPath
    )
    let viewController = coreImageViewController(for: indexPath)
    viewController.view.frame = view.bounds
    cell.contentView.addSubview(viewController.view)
    return cell
  }

  func collectionView(
    _ collectionView: UICollectionView,
    willDisplay cell: UICollectionViewCell,
    forItemAt indexPath: IndexPath
  ) {
    let viewController = coreImageViewController(for: indexPath)
    addChildViewController(viewController)
    viewController.didMove(toParentViewController: self)
  }

  func collectionView(
    _ collectionView: UICollectionView,
    didEndDisplaying cell: UICollectionViewCell,
    forItemAt indexPath: IndexPath
  ) {
    let viewController = coreImageViewController(for: indexPath)
    viewController.willMove(toParentViewController: nil)
    viewController.removeFromParentViewController()
  }
}
