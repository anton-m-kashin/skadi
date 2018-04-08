import CoreImage

protocol Filter {
  var name: String { get }
  var output: CIImage? { get } // TODO: Why is it optional?
  var inputParameters: [String: Any] { get }
}

extension Filter {

  private var filter: CIFilter {
    return CIFilter(name: name, withInputParameters: inputParameters)!
  }

  var output: CIImage? {
    return filter.outputImage
  }
}
