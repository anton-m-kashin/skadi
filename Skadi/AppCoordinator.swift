import UIKit

final class AppCoordinator {

  let window: UIWindow

  init(window: UIWindow) {
    self.window = window
  }

  private func makeRootViewController() -> UIViewController {
    #if arch(arm) || arch(arm64)
      if MetalImageView.isAvailable {
        return ViewController(imageView: MetalImageView(frame: CGRect.zero))
      } else {
        return ViewController(imageView: GLImageView(frame: CGRect.zero))
      }
    #else
      return ViewController(imageView: GLImageView(frame: CGRect.zero))
    #endif
  }

  func start() {
    self.window.rootViewController = makeRootViewController()
    window.makeKeyAndVisible()
  }
}
