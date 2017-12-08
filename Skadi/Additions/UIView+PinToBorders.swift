import UIKit

extension UIView {

  func pinToSuperviewBorders() {
    guard let superview = superview else { assertionFailure(); return }
    NSLayoutConstraint.activate(
      [
        topAnchor.constraint(equalTo: superview.topAnchor),
        bottomAnchor.constraint(equalTo: superview.bottomAnchor),
        leadingAnchor.constraint(equalTo: superview.leadingAnchor),
        trailingAnchor.constraint(equalTo: superview.trailingAnchor)
      ]
    )
  }
}
