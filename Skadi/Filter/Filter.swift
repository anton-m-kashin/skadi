import CoreImage

protocol Filter {

  var name: String { get }

  var input: CIImage? { set get }
  var output: CIImage? { get }

  var inputParameters: [String: Any] { get }
}

extension Filter {

  var output: CIImage? {
    return input?.applyingFilter(name, parameters: inputParameters)
  }
}
