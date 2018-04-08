import CoreImage

protocol ImageApplyingFilter: Filter {
  var input: CIImage? { set get }
}

extension ImageApplyingFilter {

  var output: CIImage? {
    return input?.applyingFilter(name, parameters: inputParameters)
  }
}
