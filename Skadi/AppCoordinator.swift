import UIKit

final class AppCoordinator {

  let window: UIWindow

  init(window: UIWindow) {
    self.window = window
  }

  func start() {
    self.window.rootViewController = CoreImageViewController(
      image: Pixellate(input: CIImage(image: #imageLiteral(resourceName: "Sailboat"))).output
    )
    window.makeKeyAndVisible()
  }
}
