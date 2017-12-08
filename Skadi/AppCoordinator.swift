import UIKit

final class AppCoordinator {

  let window: UIWindow

  init(window: UIWindow) {
    self.window = window
  }

  func start() {
    let image = CIImage(image: #imageLiteral(resourceName: "Sailboat"))
    self.window.rootViewController = ImagesCollectionViewController(
      images: [
        Bloom(input: image).output!,
        Edges(input: image).output!,
        Pixellate(input: image).output!,
      ]
    )
    window.makeKeyAndVisible()
  }
}
